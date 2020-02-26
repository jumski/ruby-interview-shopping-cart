# frozen_string_literal: true

class LineItem
  attr_reader :quantity

  def initialize(product)
    @product = product
    @quantity = 0
  end

  def total
    product.price * quantity
  end

  def increase_quantity
    self.quantity+= 1
  end

  def hash
    product.hash
  end

  def product_code
    product.code
  end

  private

  attr_reader :product
  attr_writer :quantity
end
