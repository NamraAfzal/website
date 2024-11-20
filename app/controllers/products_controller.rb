class ProductsController < ApplicationController
  before_action :set_cart, only: :index

  def index
    @products = Product.all.page(params[:page]).per(5)
  end

end
