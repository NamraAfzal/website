class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? } 
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

  private

  def layout_by_resource
    if devise_controller? && resource_name == :seller
      "seller"
    else
      "user"
    end
  end

end
