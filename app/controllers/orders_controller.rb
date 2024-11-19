class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[seller_orders]
  before_action :authorize_seller, only: :seller_orders
  before_action :set_cart, only: %i[show add_to_cart remove_from_cart place_order]
  before_action :find_product, only: %i[add_to_cart remove_from_cart]

  def index
    @orders = current_user.orders.where.not(status: :cart)
  end

  def show; end

  def add_to_cart
    order_item = @cart.order_items.find_or_initialize_by(product_id: @product.id)
    order_item.increment(:quantity)
    order_item.save

    redirect_to order_path(@cart), notice: 'Product added to cart!'
  end

  def remove_from_cart
    order_item = @cart.order_items.find_by(product_id: @product.id)

    if order_item
      order_item.quantity > 1 ? order_item.decrement!(:quantity) : order_item.destroy
    end

    redirect_to order_path(@cart), notice: 'Product removed from the cart!'
  end

  def place_order
    if @cart.update(status: :placed)
      redirect_to orders_path, notice: 'Order placed successfully!'
    else
      redirect_to order_path(@cart), alert: 'There was an error placing the order.'
    end
  end
  def seller_orders
    @orders = Order.joins(:order_items).where(order_items: { product_id: current_user.orders.select(:id) }).where(status: :placed).distinct
  end

  private

  def set_cart
    @cart = current_user.orders.find_by(status: :cart)
    @cart ||= current_user.orders.create(status: :cart)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def authorize_seller
    unless current_seller
      redirect_to root_path, alert: "You don't have permission to view this page."
    end
  end
end
