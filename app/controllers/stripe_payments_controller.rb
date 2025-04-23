class StripePaymentsController < ApplicationController
  def create
    order = Order.find(params[:order_id])
    
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: order.order_items.map do |item|
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: item.product.name
            },
            unit_amount: (item.price_at_purchase * 100).to_i
          },
          quantity: item.quantity
        }
      end,
      mode: 'payment',
      metadata: {
        order_id: order.id # 🔐 used in success callback
      },
      success_url: "#{orders_payment_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url
    )

    redirect_to session.url, allow_other_host: true
  end
end
