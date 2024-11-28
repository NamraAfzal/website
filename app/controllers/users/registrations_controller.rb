class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
    resource.build_address
  end

  def sign_up_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, address_attributes: [:street, :city, :state, :country])
  end
end
