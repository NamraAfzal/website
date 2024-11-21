class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @products = Product.all.page(params[:page]).per(5)
  end

end
