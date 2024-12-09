class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_order, only: :place_order
  def index
    @orders = current_user.orders.where.not(status: :cart)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def place_order
    if params[:address].present?
      current_user.update(address: params[:address])
    end

    if @order.order_items.any?
      @order.update(
        shipping_address: current_user.address,
        user_name: current_user.name,
      )
      redirect_to order_item_path(@order), notice: "Enter your card details."
    else
      redirect_to order_items_path, alert: "Your cart is empty. Cannot place order."
    end
  end

  def checkout
    @stripe_service = StripeService.new
    @user = current_user
    @order = current_user.orders.find(params[:id])
    @amount_to_be_paid = @order.order_items.sum { |item| item.product.price * item.quantity }

    begin
      @stripe_user = @stripe_service.find_or_create_order(@order, @user)
      @card = @stripe_service.create_stripe_customer_card(card_token_params, @stripe_user)

      @charge = @stripe_service.create_stripe_charge(@amount_to_be_paid, @stripe_user.id, @card.id, @order)

      ActiveRecord::Base.transaction do
        @order.update!(
          user_id: current_user.id,
          stripe_transaction_id: @charge.id,
          amount: @amount_to_be_paid,
          shipping_address: current_user.address,
          user_name: current_user.name,
          status: :placed
        )

        @order.order_items.each do |order_item|
          product = order_item.product
          if product.stock >= order_item.quantity
            product.update!(stock: product.stock - order_item.quantity)
          else
            raise StandardError, "#{product.name} does not have enough stock to fulfill this order."
          end
        end
      end
      if @order.save
        OrderMailer.user_confirmation(@order).deliver_later

        @order.order_items.includes(:product).map(&:product).map(&:seller).uniq.each do |seller|
          OrderMailer.seller_notification(@order, seller).deliver_later
        end

        redirect_to orders_path, notice: 'Payment has been successfully completed.'
      else
        render :new, alert: 'Failed to place the order.'
      end

    rescue Stripe::CardError => e
      Rails.logger.error "Stripe Card Error: #{e.message}"
      redirect_to order_items_path, alert: "Payment failed: #{e.message}"
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      redirect_to order_items_path, alert: "Payment processing error: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      redirect_to order_items_path, alert: "An unexpected error occurred. Please try again."
    end
  end

  private

  def set_cart_order
    @order = current_user.orders.find_by(status: :cart)
    redirect_to order_items_path, alert: "No active cart found." unless @order
  end

  def user_params
    params.permit(:full_name, :email, :contact_number)
  end

  def card_token_params
    params.permit(:card_number, :cvc, :exp_month, :exp_year)
  end
end
