module Api
  module Users
    class ProductsController < BaseController
      def index
        q = Product.ransack(params[:q])
        products =
          if params[:category].present?
            category = params[:category].to_i
            q.result(distinct: true).where(category_id: category).page(params[:page])
          else
            q.result(distinct: true).page(params[:page])
          end

        render json: products, serializer: ProductSerializer, status: :ok
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
