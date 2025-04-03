class Cart
    attr_reader :items
  
    def initialize(session)
      @session = session
      @session[:cart] ||= {}
    end
  
    def add_product(product_id, quantity = 1)
      @session[:cart][product_id.to_s] ||= 0
      @session[:cart][product_id.to_s] += quantity.to_i
    end
  
    def update_product(product_id, quantity)
      if quantity.to_i <= 0
        @session[:cart].delete(product_id.to_s)
      else
        @session[:cart][product_id.to_s] = quantity.to_i
      end
    end
  
    def remove_product(product_id)
      @session[:cart].delete(product_id.to_s)
    end
  
    def products
      Product.find(@session[:cart].keys).map do |product|
        [product, @session[:cart][product.id.to_s]]
      end
    end
  
    def total
      products.sum { |product, qty| product.price * qty }
    end
  end
  