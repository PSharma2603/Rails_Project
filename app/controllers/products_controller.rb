class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.includes(:category)

    if params[:q].present?
      @products = @products.where("name LIKE ?", "%#{params[:q]}%")
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Special Filters: On Sale and New
    if params[:filter].present?
      case params[:filter]
      when "on_sale"
        @products = @products.where("stock_quantity > ?", 25)
      when "new"
        @products = @products.where("created_at >= ?", 3.days.ago)
      end
    end

    @products = @products.page(params[:page]).per(5)
  end

  def show
    @product = Product.find(params[:id])
  end
end
