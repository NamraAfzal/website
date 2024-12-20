module Sellers
  class ApplicationController < ::ApplicationController
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_seller!
    skip_before_action :authenticate_user!
  end
end
