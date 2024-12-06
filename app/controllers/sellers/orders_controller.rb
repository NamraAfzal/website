module Sellers
  class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update]


    def index
      @q = Order.for_seller(current_seller).ransack(params[:q])
      @orders = @q.result(distinct: true)
    end

    def show
      @orders = Order.for_seller(current_seller)
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
        redirect_to sellers_order_path
        respond_to do |format|
          format.html do
            flash[:success] = "Order status updated successfully."
            redirect_to sellers_order_path
          end
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Failed to update order status."
            render :edit
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("order_#{@order.id}", partial: "sellers/orders/order", locals: { order: @order })
          end
        end
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
