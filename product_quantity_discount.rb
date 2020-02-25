# frozen_string_literal: true

class ProductQuantityDiscount
  def initialize(product_code:, min_quantity:, new_price:)
    @product_code = product_code
    @min_quantity = min_quantity
    @new_price = new_price
  end

  def applies_to_total?
    false
  end

  def applies_to_item?
    true
  end

  def apply(item, quantity)
    return item unless applies?(item, quantity)

    ItemDecorator.new(item, new_price: new_price)
  end

  private

  attr_reader :product_code, :min_quantity, :new_price

  def applies?(item, quantity)
    product_code == item.code && quantity >= min_quantity
  end

  class ItemDecorator < SimpleDelegator
    def initialize(item, new_price:)
      super(item)
      @new_price = new_price
    end

    def price
      new_price
    end

    attr_reader :new_price
  end
  private_constant :ItemDecorator
end

