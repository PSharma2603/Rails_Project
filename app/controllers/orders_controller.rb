class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]

  def new
    @order = current_user ? current_user.orders.build : Order.new
    @provinces = Province.all

    # Build address only for logged-in users if not already present
    @order.build_address if current_user&.address.blank?
  end

  def create
    @order = current_user ? current_user.orders.build(order_params) : Order.new(order_params)

    # Build order_items from cart
    @order_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find(product_id)
      OrderItem.new(product: product, quantity: quantity, price: product.price)
    end

    @order.order_items = @order_items

    # Calculate tax from province
    province_id = order_params[:address_attributes][:province_id]
    province = Province.find_by(id: province_id)
    subtotal = @order_items.sum { |item| item.price * item.quantity }
    tax_total = province ? subtotal * (province.gst + province.pst + province.hst) : 0
    @order.total = subtotal + tax_total

    if @order.save
      # Save address to user if they don’t already have one
      if current_user&.address.blank? && @order.address.present?
        current_user.address = @order.address
        current_user.save
      end

      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed successfully."
    else
      @provinces = Province.all
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

  def order_params
    params.require(:order).permit(
      address_attributes: [:street, :city, :postal_code, :province_id]
    )
  end
end
