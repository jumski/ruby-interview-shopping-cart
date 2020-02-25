# frozen_string_literal: true

ProductQuantityDiscount = Struct.new(:product_code, :min_quantity, :new_price, keyword_init: true) do
  def applies_to_total?
    false
  end

  def applies_to_item?
    true
  end

  def applies?(item, quantity)
    product_code == item.code && quantity >= min_quantity
  end

  def apply(item, quantity)
    return item unless applies?(item, quantity)

    ItemDecorator.new(item, new_price: new_price)
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
  # private_constant :ItemDecorator
end

