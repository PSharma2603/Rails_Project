class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]

  def new
    @order = Order.new
    @provinces = Province.all

    # Show address form only if user has no saved profile address
    @order.build_address if current_user.nil? || current_user.address.blank?
  end

  def create
    @order = Order.new
    @order.user = current_user if current_user

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

    province = Province.find_by(id: @order.address&.province_id)
    gst = province&.gst.to_f * subtotal
    pst = province&.pst.to_f * subtotal
    hst = province&.hst.to_f * subtotal

    @order.total_price = subtotal + gst + pst + hst

    if @order.save
      session[:cart] = {}
      redirect_to create_checkout_session_path(@order), method: :post, allow_other_host: true
    else
      @provinces = Province.all
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end
  def payment_success
    session_id = params[:session_id]
    session = Stripe::Checkout::Session.retrieve(session_id)
  
    if session && session.payment_status == "paid"
      order = Order.find_by(id: session.metadata.order_id) || Order.last # fallback
  
      if order
        order.update(paid: true, stripe_payment_id: session.payment_intent)
        redirect_to order_path(order), notice: "Payment completed successfully!"
      else
        redirect_to root_path, alert: "Order not found"
      end
    else
      redirect_to root_path, alert: "Payment not verified"
    end
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
