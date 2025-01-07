module Sellers
  class DashboardController < ApplicationController

    def index
      @products = current_seller.products
      @total_products = current_seller.products.count
      product_count = OrderItem.joins(:product).where(products: { seller_id: current_seller.id })
      @total_orders = product_count.count
      @total_sales = product_count.sum("order_items.quantity * products.price")
      @downloads = current_seller.downloads.order(created_at: :desc)
    end
  end
end
