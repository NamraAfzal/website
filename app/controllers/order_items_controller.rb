class OrderItemsController < ApplicationController
  before_action :set_order, only: [:index, :destroy]

  def index
    @order_items = @order.order_items || []
  end
  # def index
  #   @order_items = current_user.order_items # or the correct association
  #   @OrderItem = @order_items.first # Example logic, adjust as needed
  # end

  def create
    @order = current_user.orders.find_or_create_by(status: :cart)
    product = Product.find(params[:product_id])
    order_item = @order.order_items.find_or_initialize_by(product: product)
    if order_item.new_record?
      order_item.quantity = 1
    else
      order_item.quantity += 1
    end

    if order_item.save
      redirect_to order_items_path, notice: "#{product.name} added to your cart."
    else
      redirect_to product_path(product), alert: "Failed to add product to cart."
    end
  end

  def create
    @order = current_user.orders.find_or_create_by(status: :cart)
    product = Product.find(params[:product_id])

    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    order_item = @order.order_items.find_or_initialize_by(product: product)

    if order_item.new_record?
      order_item.quantity = quantity
    else
      order_item.quantity += quantity
    end

    if order_item.save
      redirect_to order_items_path, notice: "#{product.name} added to your cart."
    else
      redirect_to product_path(product), alert: "Failed to add product to cart."
    end
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id], order_id: @order.id)

    if @order_item
      if @order_item.quantity > 1
        @order_item.decrement!(:quantity)
        flash[:notice] = 'Item quantity decreased.'
      else
        @order_item.destroy
        flash[:notice] = 'Item was successfully removed from your cart.'
      end
    else
      flash[:alert] = 'Item could not be found.'
    end

    redirect_to order_items_path
  end

  private

  def set_order
    @order = current_user.orders.find_or_create_by(status: :cart)
  end
end
