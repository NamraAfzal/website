module Sellers

  class OrdersController < ApplicationController
    def seller_orders
      @orders = Order.joins(:order_items).where(order_items: { product_id: current_seller.products.select(:id) }).where(status: :placed).distinct

      render :seller_orders
    end
  end
end
