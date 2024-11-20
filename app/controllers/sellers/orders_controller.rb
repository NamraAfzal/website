module Sellers
  class OrdersController < ApplicationController
    before_action :set_order, only: [:update]
    def seller_orders
      @orders = Order.joins(:order_items).where(order_items: { product_id: current_seller.products.select(:id) }).where(status: :placed).distinct

      render :seller_orders
    end


    def update
      status = order_params[:status].to_i
      if @order.update(status: status)
        flash[:success] = "Order status updated successfully."
        redirect_to sellers_orders_path
      else
        flash[:error] = "Failed to update order status."
        render :seller_orders
      end
    end

    private

    def set_order
      @order = Order.joins(:order_items)
                    .where(order_items: { product_id: current_seller.products.pluck(:id) })
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
