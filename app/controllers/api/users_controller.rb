class Api::UsersController < Api::BaseController

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'User created successfully', user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
      if @user.update(user_params)
        render json: { message: 'User updated successfully', user: @user }
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { message: 'User deleted successfully' }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :address)
  end
end
