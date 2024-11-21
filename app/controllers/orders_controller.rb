class OrdersController < ApplicationController
  before_action :current_cart, only: %i[show add_to_cart remove_from_cart place_order]
  before_action :find_product, only: %i[add_to_cart remove_from_cart]

  def index
    @orders = current_user.orders.where.not(status: :cart)
  end

  def show; end

  def add_to_cart
    order_item = @cart.order_items.find_or_initialize_by(product_id: @product.id)
    if order_item.new_record?
      order_item.quantity = 1
    else
      order_item.increment(:quantity)
    end
    if order_item.save
      redirect_to order_path(@cart), notice: 'Product added to cart!'
    else
      redirect_to product_path(@product), alert: "Failed to add product to cart: #{order_item.errors.full_messages.to_sentence}"
    end
  end

  def remove_from_cart
    order_item = @cart.order_items.find_by(product_id: @product.id)

    if order_item
      order_item.quantity > 1 ? order_item.decrement!(:quantity) : order_item.destroy
    end

    redirect_to order_path(@cart), notice: 'Product removed from the cart!'
  end

  def place_order
    if @cart.update(shipping_address: params[:order][:shipping_address], status: :placed)
      redirect_to orders_path, notice: 'Order placed successfully!'
    else
      redirect_to order_path(@cart), alert: 'There was an error placing the order.'
    end
  end

  private

  def current_cart
    @cart = current_user.orders.find_by(status: :cart)
    @cart ||= current_user.orders.create(status: :cart)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

end
