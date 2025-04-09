class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]

  def new
    @order = Order.new
    @provinces = Province.all
  
    # Show address form only if user has no saved profile address
    if current_user && current_user.address.blank?
      @order.build_address
    end
  end
    

  def create
    @order = Order.new
    @order.user = current_user if current_user
  
    # Copy address from user profile if available
    if current_user&.province_id
      @order.build_address(
        street_address: current_user.address&.street_address,
        city: current_user.address&.city,
        postal_code: current_user.address&.postal_code,
        province_id: current_user.province_id
      )
    else
      @order.assign_attributes(order_params)
    end
  
    # Build order items
    subtotal = 0
    @cart.items.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
  
      line_total = product.price * quantity.to_i
      subtotal += line_total
  
      @order.order_items.build(
        product: product,
        quantity: quantity,
        price_at_purchase: product.price
      )
    end
  
    # Calculate tax
    province = Province.find_by(id: @order.address&.province_id)
    gst = province&.gst.to_f * subtotal
    pst = province&.pst.to_f * subtotal
    hst = province&.hst.to_f * subtotal
  
    @order.total_price = subtotal + gst + pst + hst
  
    if @order.save
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
      address_attributes: [:street_address, :city, :postal_code, :province_id]
    )
  end
end
