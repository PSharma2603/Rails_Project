class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.includes(:category).all
  
    if params[:q].present?
      query = "%#{params[:q].downcase}%"
      @products = @products.where("LOWER(name) LIKE ?", query)
    end
  
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end
  

  def show
    @product = Product.find(params[:id])
  end
end
