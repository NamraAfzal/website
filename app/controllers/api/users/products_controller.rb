module Api
  module Users
    class ProductsController < BaseController
      respond_to :json
      def index
        @q = Product.ransack(params[:q])
        @products =
        if params[:category].present?
          category = params[:category].to_i
          @products = @q.result(distinct: true).page(params[:page]).where(category_id: category)
          render json: { products: @products, message: "Products in the selected category" },status: :ok
        else
          @products = @q.result(distinct: true).page(params[:page])
          render json: { products: @products, message: "ALL Products." },status: :ok
        end
      end

      def show
        @product = Product.find(params[:id])
        render json: @product, status: :ok
      end
    end
  end
end
