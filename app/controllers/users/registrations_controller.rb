class Users::RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :address)
  end
end
