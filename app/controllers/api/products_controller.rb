class Api::ProductsController < Api::Sellers::BaseController

  def index
    @products = Product.all
    render json: @products, each_serializer: ProductSerializer
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: { message: 'User created successfully', product: @product }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
      if @product.update(product_params)
        render json: { message: 'User updated successfully', product: @product }
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def show
    @product = Product.find(params[:id])
    render json: @product, serializer: ProductSerializer
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    render json: { message: 'User deleted successfully' }
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :stock, :image, :seller_id)
  end
end
