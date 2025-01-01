class Api::DashboardController < Api::Sellers::BaseController
  def index
    products = current_seller.products
    product_count = OrderItem.joins(:product).where(products: { seller_id: current_seller.id })
    total_orders = product_count.count
    total_sales = product_count.sum("order_items.quantity * products.price")

    render json: {
      products: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer),
      total_products: products.count,
      total_orders:,
      total_sales:
    }, status: :ok
  end
end
