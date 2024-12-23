module Api
  module Sellers
    class OrdersController < BaseController
      before_action :set_order, only: %i[show edit update]
      def index
        @q = Order.for_seller(current_seller).order(created_at: :desc).ransack(params[:q])
        @orders = @q.result(distinct: true)
        render json: @orders, status: :ok
      end

      def show
        @orders = Order.for_seller(current_seller).order(created_at: :desc)
        @selected_order = @orders.find_by(id: params[:id])
        @q = Order.ransack(params[:q])
        @selected_order = @order
        render json: @selected_order, status: :ok
      end
      def edit
        @order = current_seller.orders.find(params[:id])
        render json: @order, status: :ok
      end

      def update
        @order = current_seller.orders.find(params[:id])
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

        def order_params
          params.require(:order).permit(:status)
        end

    end
  end
end
