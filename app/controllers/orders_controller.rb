class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_order, only: [:place_order]

  def index
    @orders = current_user.orders.where.not(status: :cart)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def place_order
    if @order.order_items.any?
      @order.update(
        shipping_address: current_user.address,
        user_name: current_user.name,
        status: :placed
      )

      redirect_to orders_path, notice: "Order successfully placed!"
    else
      redirect_to order_items_path, alert: "Your cart is empty. Cannot place order."
    end
  end

  private

  def set_cart_order
    @order = current_user.orders.find_by(status: :cart)
    redirect_to order_items_path, alert: "No active cart found." unless @order
  end
end
