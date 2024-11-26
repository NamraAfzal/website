class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # @products = Product.all.page(params[:page]).per(5)
      if params[:category_id].present?
        @products = Product.where(category_id: params[:category_id])
      else
        @products = Product.all
      end
  end

  def show
    @product = Product.find(params[:id])
  end

end
