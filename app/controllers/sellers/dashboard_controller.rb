class Sellers::DashboardController < ApplicationController
  before_action :authenticate_seller!
  skip_before_action :authenticate_user!

  def index
    @seller = current_seller
    @products = @seller.products
    @total_products = @products.count
    @total_orders = OrderItem.joins(:product).where(products: { seller_id: @seller.id }).count
    @total_sales = OrderItem.joins(:product)
                            .where(products: { seller_id: @seller.id })
                            .sum("order_items.quantity * products.price")
  end
end
