module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user!
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
          products: @products.map { |product| product_response(product) },
          pagination: pagination_meta(@products)
        }, status: :ok
      end

      def show
        @product = Product.find(params[:id])
        render json: { product: product_response(@product),status: 200 }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found',status: 404 }, status: :not_found
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

      def product_response(product)
        {
          id: product.id,
          name: product.name,
          price: product.price,
          description: product.description,
          category_id: product.category_id,
          image_urls: product_image_urls(product)
        }
      end

      def product_image_urls(product)
        if product.image.attached?
          product.image.map { |image| Rails.application.routes.url_helpers.url_for(image) }
        else
          []
        end
      end
    end
  end
end
