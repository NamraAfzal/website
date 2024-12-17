module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_default_response_format

      def index
        @q = Product.ransack(params[:q])
        @products =
          if params[:category].present?
            category = params[:category].to_i
            @q.result(distinct: true).where(category_id: category).page(params[:page])
          else
            @q.result(distinct: true).page(params[:page])
          end

        render json: {
          products: @products,
          pagination: pagination_meta(@products)
        }, status: :ok
      end

      def show
        @product = Product.find(params[:id])
        render json: { product: @product, status: 200 }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found', status: 404 }, status: :not_found
      end

      private

      def set_default_response_format
        request.format = :json
      end

      def pagination_meta(products)
        {
          current_page: products.current_page,
          total_pages: products.total_pages,
          total_count: products.total_count
        }
      end
    end
  end
end
