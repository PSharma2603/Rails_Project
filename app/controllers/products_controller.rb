class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.includes(:category).all
  end

  def show
    @product = Product.find(params[:id])
  end
end
