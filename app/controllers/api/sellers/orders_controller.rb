module Api
  module Sellers
    class OrdersController < BaseController
      before_action :set_seller_order, only: %i[index show]
      before_action :set_order, only: %i[show update]

      def index
        q = @seller_order.ransack(params[:q])
        orders = q.result(distinct: true)
        render json: orders, status: :ok
      end

      def show
        orders = @seller_order
        selected_order = orders.find_by(id: params[:id])
        q = Order.ransack(params[:q])
        selected_order = @order
        render json: selected_order, status: :ok
      end

      def update
        if @order.update(order_params)
          render json: { message: "Order status updated successfully.", order: @order },status: :ok
        else
          render json: { error: "Failed to update order status.", order: @order }, status: :ok
        end
      end

      private

        def set_order
          @order = Order.find(params[:id])
        end

        def set_seller_order
          @seller_order = Order.for_seller(current_seller).order(created_at: :desc)
        end

        def order_params
          params.require(:order).permit(:status)
        end
    end
  end
end
