class Api::OrdersController < Api::Users::BaseController  
  before_action :set_cart_order, only: %i[show payment place_order checkout]

  def index
    @orders = current_user.orders.where.not(status: :cart)
    render json: @orders, status: :ok
  end

  def show
    render json: { order: @order, order_items: @order.order_items }, status: :ok
  end

  def payment
    render json: { order: @order, order_items: @order.order_items }, status: :ok
  end

  def place_order
    if params[:address].present?
      current_user.update(address: params[:address])
    end

    if @order.order_items.any?
      @order.update(
        shipping_address: current_user.address,
        user_name: current_user.name,
        status: :placed
      )
      render json: { message: "Order placed successfully. Proceed to payment.", order: @order }, status: :ok
    else
      render json: { error: "Your cart is empty. Cannot place the order." }, status: :unprocessable_entity
    end
  end

  def checkout
    @stripe_service = StripeService.new
    @user = current_user
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

      OrderMailer.user_confirmation(@order).deliver_later
      @order.order_items.includes(:product).map(&:product).map(&:seller).uniq.each do |seller|
        OrderMailer.seller_notification(@order, seller).deliver_later
      end

      render json: { message: 'Payment has been successfully completed.', order: @order }, status: :ok
    rescue Stripe::CardError => e
      render json: { error: "Payment failed: #{e.message}" }, status: :payment_required
    rescue Stripe::StripeError => e
      render json: { error: "Payment processing error: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def set_cart_order
    @order = current_user.orders.find_by(status: :cart)
    render json: { error: "No active cart found." }, status: :not_found unless @order
  end

  def card_token_params
    params.permit(:card_number, :cvc, :exp_month, :exp_year)
  end
end
