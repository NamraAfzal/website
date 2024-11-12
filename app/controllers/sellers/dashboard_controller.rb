module Sellers
  class DashboardController < ApplicationController
    before_action :authenticate_seller!

    def index; end
  end
end
