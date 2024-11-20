module Sellers
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[show edit update destroy]

    def index
      @products = current_seller.products
    end

    def new
      @product = Product.new
    end

    def show; end

    def create
      @product = current_seller.products.build(product_params)
      if @product.save
        redirect_to sellers_products_path, notice: "Product created successfully."
      else
        render :new
      end
    end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to sellers_product_path(@product), notice: "Product updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to sellers_products_path, notice: "Product deleted successfully."
    end

    private

    def set_product
      @product = current_seller.products.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end
  end


end
