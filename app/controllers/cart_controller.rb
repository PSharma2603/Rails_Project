class CartController < ApplicationController
  def show
    @cart = Cart.new(session[:cart] || {})
  end

  def add
    cart = Cart.new(session[:cart] || {})
    cart.add_product(params[:product_id], params[:quantity])
    session[:cart] = cart.items
    redirect_to cart_path
  end

  def update
    cart = Cart.new(session[:cart] || {})
    cart.update_product(params[:product_id], params[:quantity])
    session[:cart] = cart.items
    redirect_to cart_path
  end

  def remove
    cart = Cart.new(session[:cart] || {})
    cart.remove_product(params[:product_id])
    session[:cart] = cart.items
    redirect_to cart_path
  end
end
