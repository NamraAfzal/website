module Sellers
  class OrdersController < ApplicationController
    before_action :set_order, only: [:update]

    def index
      @orders = Order.joins(:order_items).where(order_items: { product_id: current_seller.products.select(:id) }).where(status: :placed).distinct
    end

    def show
      @orders = Order.joins(:order_items).where(order_items: { product_id: current_seller.products.select(:id) }).distinct
      @selected_order = @orders.find_by(id: params[:id])

      if @selected_order.nil?
        redirect_to sellers_orders_path, alert: "Order not found."
      end
    end

    def update
      status = order_params[:status].to_i
      if @order.update(status: status)
        respond_to do |format|
          format.html do
            flash[:success] = "Order status updated successfully."
            redirect_to sellers_orders_path
          end
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Failed to update order status."
            render :seller_orders
          end
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@order, partial: "sellers/orders/order", locals: { order: @order }) }
        end
      end
    end

    private

    def set_order
      @order = Order.joins(:order_items)
                    .where(order_items: { order_id: current_seller.products.pluck(:id) })
                    .find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Order not found."
      redirect_to sellers_orders_path
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
