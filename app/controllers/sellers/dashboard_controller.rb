module Sellers
  class DashboardController < ApplicationController
    before_action :authenticate_seller!

    def index
      @products = current_seller.products
    end
  end
end

