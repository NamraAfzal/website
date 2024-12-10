module Sellers
  class OrdersController < ApplicationController
    before_action :set_order, only: %i[show edit update]

    def index
      @q = Order.for_seller(current_seller).order(created_at: :desc).ransack(params[:q])
      @orders = @q.result(distinct: true)
    end

    def show
      @orders = Order.for_seller(current_seller).order(created_at: :desc)
      @selected_order = @orders.find_by(id: params[:id])
      @q = Order.ransack(params[:q])
      @selected_order = @order
      redirect_to sellers_orders_path, alert: "Order not found." if @selected_order.nil?
    end

    def edit
      @order = current_seller.orders.find(params[:id])
    end

    def update
      @order = current_seller.orders.find(params[:id])
      if @order.update(order_params)
        redirect_to sellers_order_path, notice: "Order status updated successfully."
      else
        redirect_to sellers_order_path, notice: "Failed to update order status."
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
