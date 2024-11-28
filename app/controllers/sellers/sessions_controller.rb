class Sellers::SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(resource)
    sellers_dashboard_path
  end
end
