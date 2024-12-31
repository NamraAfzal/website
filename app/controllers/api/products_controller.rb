class Api::ProductsController < Api::Sellers::BaseController
  before_action :set_product, only: %i[update show destroy]

  def index
    products = Product.all
    render json: products, each_serializer: ProductSerializer
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: { message: 'Product created successfully', product: product }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
      if @product.update(product_params)
        render json: { message: 'Product updated successfully', product: @product }
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def show
    render json: @product, serializer: ProductSerializer
  end

  def destroy
    @product.destroy
    render json: { message: 'Product deleted successfully' }
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :stock, :image, :seller_id)
  end
end
