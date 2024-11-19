class ProductsController < ApplicationController
  before_action :set_cart, only: :index

  def index
    @products = Product.all.page(params[:page]).per(5)
  end

  private

  def set_cart
    @current_cart = current_user.orders.find_or_create_by(status: :cart)
  end

end
