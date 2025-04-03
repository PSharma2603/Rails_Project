class CartController < ApplicationController
  def show
    @cart = Cart.new(session)
  end

  def add
    Cart.new(session).add_product(params[:product_id], params[:quantity])
    redirect_to cart_path
  end

  def update
    Cart.new(session).update_product(params[:product_id], params[:quantity])
    redirect_to cart_path
  end

  def remove
    Cart.new(session).remove_product(params[:product_id])
    redirect_to cart_path
  end
end
