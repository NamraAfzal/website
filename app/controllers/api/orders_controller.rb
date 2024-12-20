class Api::OrdersController < Api::Users::BaseController

  def index
    @orders = current_user.orders.where.not(status: :cart)
    render json: @orders
  end

  def show
    @order = Order.find(params[:id]).order_items
    render json: @order
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      render json: { message: 'User updated successfully', order: @order }
    else
      render json: {errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create

  end
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: { message: 'User created successfully', product: @product }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def checkout
    @stripe_service = StripeService.new
    @user = current_user
    @order = @user.orders.find(params[:id])
    @amount_to_be_paid = @order.order_items.sum { |item| item.product.price * item.quantity }

    begin
      @stripe_user = @stripe_service.find_or_create_order(@order, @user)
      @card = @stripe_service.create_stripe_customer_card(card_token_params, @stripe_user)
      @charge = @stripe_service.create_stripe_charge(@amount_to_be_paid, @stripe_user.id, @card.id, @order)

      ActiveRecord::Base.transaction do
        @order.update!(
          user_id: @user.id,
          stripe_transaction_id: @charge.id,
          amount: @amount_to_be_paid,
          shipping_address: @user.address,
          user_name: @user.name,
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

      render json: {
        message: 'Payment has been successfully completed.',
        order: @order,
        charge_id: @charge.id
      }, status: :ok

    rescue Stripe::CardError => e
      Rails.logger.error "Stripe Card Error: #{e.message}"
      render json: { error: "Payment failed: #{e.message}" }, status: :unprocessable_entity
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      render json: { error: "Payment processing error: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  private
  def card_token_params
    params.require(:card).permit(:token)
  end

  def order_params
    params.require(:order).permit(:shipping_address, :user_name)
  end
end
