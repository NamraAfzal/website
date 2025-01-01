module Api
  module Users
    class ProductsController < BaseController
      def index
        products = Product.ransack(params[:q]).result(distinct: true).page(params[:page])

        render json: products, status: :ok
      end

      def show
        product = Product.find_by(id: params[:id])
        if product
          render json: product, serializer: ProductSerializer, status: :ok
        else
          render json: { error: "Product not found" }, status: :not_found
        end
      end
    end
  end
end
