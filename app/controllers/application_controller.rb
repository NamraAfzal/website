class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Seller)
      seller_dashboard_path
    else
      root_path
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
