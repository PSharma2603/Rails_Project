class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]

  def new
    @order = current_user ? current_user.orders.build : Order.new
    @provinces = Province.all
    @order.build_address if current_user&.address.blank?
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user if current_user
  
    # Calculate subtotal and build order items
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
  
    # Fetch province and calculate tax
    province_id = order_params[:address_attributes][:province_id]
    province = Province.find_by(id: province_id)
  
    gst = province&.gst.to_f * subtotal
    pst = province&.pst.to_f * subtotal
    hst = province&.hst.to_f * subtotal
  
    @order.total_price = subtotal + gst + pst + hst
  
    if @order.save
      if current_user && current_user.address.blank? && @order.address.present?
        current_user.create_address(@order.address.attributes.except("id", "addressable_type", "addressable_id", "created_at", "updated_at"))
      end
  
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed successfully."
    else
      Rails.logger.error "ORDER ERROR: #{@order.errors.full_messages}"
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
