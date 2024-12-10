class OrderItemsController < ApplicationController
  before_action :set_order, only: :create
  before_action :set_order_item, only: %i[destroy update_quantity]

  def create
    product = Product.find(params[:product_id])
    order_item = @order.order_items.find_or_initialize_by(product:)

    if params[:quantity].present?
      order_item.quantity = params[:quantity].to_i
    else
      order_item.quantity = order_item.new_record? ?  1 : order_item.quantity + 1
    end

    if order_item.save
      redirect_to product_path(product), notice: "#{product.name} added to your cart."
    else
      redirect_to product_path(product), alert: "Failed to add product to cart."
    end
  end

  def destroy
    @order_item.destroy
    redirect_to order_path, notice: 'Product removed from cart.'
  end

  def update_quantity
    if params[:operation] == "increase"
      @order_item.increment!(:quantity)
      redirect_to order_path, notice: 'Cart updated successfully.'
    elsif params[:operation] == "decrease" && @order_item.quantity > 1
      @order_item.decrement!(:quantity)
      redirect_to order_path, notice: 'Cart updated successfully.'
    end
  end

  private

  def set_order
    @order = current_user.orders.find_or_create_by(status: :cart)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end
end
