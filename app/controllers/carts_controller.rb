class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = current_user.cart
  end

  def show
    @cart = current_user.cart || Cart.create(user: current_user)
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    cart = Cart.find(params[:id])

    cart_item = cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.increment(:quantity)
      cart_item.save
    else
      cart.cart_items.create(product: product, quantity: 1)
    end

    redirect_to cart_path(cart), notice: 'Product added to cart!'

  end

  def remove_from_cart
    product = Product.find(params[:product_id])
    cart = current_user.cart
    cart_item = cart.cart_items.find_by(product_id: product.id)

    if cart_item.quantity > 1
      cart_item.update(quantity: cart_item.quantity - 1)
    else
      cart_item.destroy
    end

    redirect_to cart_path(cart), notice: 'Product deleted from the cart!'

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path(@cart) }
    end

  end
end
