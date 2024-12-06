class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if params[:category].present?
      category = params[:category].to_i
      @products = Product.where(category_id: category)
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find(params[:id])
  end

end
