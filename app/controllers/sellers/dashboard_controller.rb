class Sellers::DashboardController < ApplicationController
  before_action :authenticate_seller!
  skip_before_action :authenticate_user!

  def index
    @products = Product.all
  end
end
