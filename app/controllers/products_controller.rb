class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @q = Product.ransack(params[:q])
    @products =
    if params[:category].present?
      category = params[:category].to_i
      @products = @q.result(distinct: true).page(params[:page]).where(category_id: category)
    else
      @products = @q.result(distinct: true).page(params[:page])
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
