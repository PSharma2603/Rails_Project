class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]

  def new
    @order = Order.new
    @provinces = Province.all
  end

  def create
    @order = current_user.orders.build
    @order_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find(product_id)
      OrderItem.new(product: product, quantity: quantity, price: product.price)
    end

    @order.order_items = @order_items
    @order.total = @order_items.sum { |item| item.price * item.quantity }

    if @order.save
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed successfully."
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def set_cart
    @cart = Cart.new(session[:cart] || {})
  end
end
