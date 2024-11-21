class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end
end
