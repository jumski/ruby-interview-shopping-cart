# frozen_string_literal: true

require './line_items.rb'
require './line_item.rb'

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

  def applies?(line_items)
    matching_line_item = line_items[product_code]
    matching_line_item && applies_to_line_item?(matching_line_item)
  end

  def apply(line_items)
    decorated_items = line_items.map { |item| decorate_if_applies(item) }

    LineItems.new(decorated_items)
  end

  private

  attr_reader :product_code, :min_quantity, :new_price

  def decorate_if_applies(item)
    if applies_to_line_item?(item)
      LineItemDecorator.new(item, new_price: new_price)
    else
      item
    end
  end

  def applies_to_line_item?(line_item)
    line_item.quantity >= min_quantity
  end

  class LineItemDecorator < SimpleDelegator
    def initialize(item, new_price:)
      super(item)
      @new_price = new_price
    end

    def price
      new_price
    end

    attr_reader :new_price
  end
  private_constant :LineItemDecorator
end
