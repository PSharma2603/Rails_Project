class Cart
  attr_reader :items

  def initialize(initial_items)
    @items = initial_items || {}
  end

  def add_product(product_id, quantity)
    product_id = product_id.to_s
    if @items[product_id]
      @items[product_id] += quantity.to_i
    else
      @items[product_id] = quantity.to_i
    end
  end

  def update_product(product_id, quantity)
    product_id = product_id.to_s
    if quantity.to_i <= 0
      @items.delete(product_id)
    else
      @items[product_id] = quantity.to_i
    end
  end

  def remove_product(product_id)
    @items.delete(product_id.to_s)
  end

  def products
    product_ids = @items.keys.select { |k| k =~ /^\d+$/ }
    products = Product.where(id: product_ids)
    products.map { |product| [product, @items[product.id.to_s]] }.to_h
  end

  def total
    products.sum do |product, qty|
      product.price.to_f * qty.to_i
    end
  end
  def items
    @items
  end
  
end
