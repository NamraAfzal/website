module Sellers
  class OrdersController < ApplicationController
    before_action :set_order, only: [:update]
    def show
      @orders = Order.joins(:order_items).where(order_items: { product_id: current_seller.products.select(:id) }).where(status: :placed).distinct

      render :show
    end

    def update
      status = order_params[:status].to_i
      if @order.update(status: status)
        respond_to do |format|
          format.html do
            flash[:success] = "Order status updated successfully."
            redirect_to sellers_orders_path
          end
          format.turbo_stream # Respond with a Turbo Stream template
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
