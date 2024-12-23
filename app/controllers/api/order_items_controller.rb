class Api::OrderItemsController < Api::Users::BaseController
  before_action :set_order, only: :create
  before_action :set_order_item, only: %i[destroy update_quantity]

  def create
    product = Product.find_by(id: params[:product_id])
    unless product
      render json: { error: "Product not found" }, status: :not_found and return
    end

    order_item = @order.order_items.find_or_initialize_by(product: product)
    order_item.quantity = params[:quantity].present? ? params[:quantity].to_i : (order_item.new_record? ? 1 : order_item.quantity + 1)

    if order_item.save
      render json: { message: "#{product.name} added to your cart.", order_item: order_item }, status: :created
    else
      render json: { error: "Failed to add product to cart.", details: order_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @order_item.destroy
      render json: { message: "Product removed from cart." }, status: :ok
    else
      render json: { error: "Failed to remove product from cart." }, status: :unprocessable_entity
    end
  end

  def update_quantity
    case params[:operation]
    when "increase"
      if @order_item.increment!(:quantity)
        render json: { message: "Cart updated successfully.", order_item: @order_item }, status: :ok
      else
        render json: { error: "Failed to update cart." }, status: :unprocessable_entity
      end
    when "decrease"
      if @order_item.quantity > 1 && @order_item.decrement!(:quantity)
        render json: { message: "Cart updated successfully.", order_item: @order_item }, status: :ok
      else
        render json: { error: "Cannot decrease quantity further." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid operation." }, status: :bad_request
    end
  end

  private

  def set_order
    @order = current_user.orders.find_or_create_by(status: :cart)
  end

  def set_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    unless @order_item
      render json: { error: "Order item not found." }, status: :not_found
    end
  end
end
