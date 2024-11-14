# app/controllers/sellers/sessions_controller.rb
class Sellers::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    sellers_products_path
  end
end
