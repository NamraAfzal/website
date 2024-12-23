class Api::DashboardController < Api::Sellers::BaseController
  def index
    @products = current_seller.products
    @total_products = current_seller.products.count
    product_count = OrderItem.joins(:product).where(products: { seller_id: current_seller.id })
    @total_orders = product_count.count
    @total_sales = product_count.sum("order_items.quantity * products.price")
    render json: { products: @products, total_products: @total_products, total_orders: @total_orders, total_sales: @total_sales }, status: :ok
  end
end
