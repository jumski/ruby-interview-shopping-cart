# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require './product.rb'
require './line_item.rb'
require './line_items.rb'

class UnitTest < MiniTest::Unit::TestCase
  def test_product_equals_based_on_code
    assert_equal Product.new(code: 'a'), Product.new(code: 'a')
    assert Product.new(code: 'a') != Product.new(code: 'b')
  end

  def test_line_item_equals_based_on_product
    product = Product.new(code: 'a')

    assert_equal LineItem.new(product), LineItem.new(product)
  end

  def test_line_items_track_quantity_for_products
    product = Product.new(code: 'a', price: 10)

    line_items = LineItems.new
    line_items.add(product)
    line_items.add(product)

    assert_equal 20, line_items.total
  end
end
