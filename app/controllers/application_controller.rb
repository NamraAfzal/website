class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart

  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Seller)
      sellers_products_path
    else
      products_path
    end
  end

  private

  def layout_by_resource
    if devise_controller? && resource_name == :seller
      "seller"
    else
      "user"
    end
  end

  def current_cart
    @current_cart ||= current_user.orders.find_or_create_by(status: :cart)
  end

end
