class Api::SellersController < Api::Sellers::BaseController

  def index
    @sellers = Seller.all
    render json: @sellers
  end

  def create
    @seller = Seller.new(seller_params)
    if @seller.save
      render json: { message: 'Seller created successfully', seller: @seller }, status: :created
    else
      render json: { errors: @seller.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @seller = Seller.find(params[:id])
      if @seller.update(seller_params)
        render json: { message: 'Seller updated successfully', seller: @seller }
      else
        render json: { errors: @seller.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def show
    @seller = Seller.find(params[:id])
    render json: @seller
  end

  def destroy
    @seller = Seller.find(params[:id])
    @seller.destroy
    render json: { message: 'Seller deleted successfully' }
  end

  private

  def seller_params
    params.require(:seller).permit(:email, :password, :company_name, :store_url)
  end
end
