class UsersController < ApplicationController
  def new
    @user = User.new
    @user.build_address
  end

  def edit
    @user.build_address if @user.address.nil?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, address_attributes: [:street, :city, :state, :zip_code, :country])
  end
end
