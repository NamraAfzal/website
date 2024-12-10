class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  helper_method :current_cart

  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Seller)
      sellers_dashboard_index_path
    else
      products_path
    end
  end

  def current_cart
    if current_user
      @current_cart ||= current_user.orders.find_or_create_by(status: :cart)
    else
      @current_cart ||= Order.find_or_create_by(id: session[:cart_id], status: :cart) do |order|
        order.guest = true
      end
      session[:cart_id] = @current_cart.id
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

end
