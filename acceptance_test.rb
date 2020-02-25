# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require './checkout.rb'
require './product.rb'
require './total_discount.rb'
require './product_quantity_discount.rb'

class AcceptanceTest < MiniTest::Unit::TestCase
  def red_scarf
    Product.new(code: '001', name: 'Red Scarf', price: 9.25)
  end

  def silver_cufflinks
    Product.new(code: '002', name: 'Silver cufflinks', price: 45.00)
  end

  def silk_dress
    Product.new(code: '003', name: 'Silk dress', price: 19.95)
  end

  def promotional_rules
    [
      TotalDiscount.new(threshold: 60.00, discount: 0.1),
      ProductQuantityDiscount.new(
        product_code: red_scarf.code, min_quantity: 2, new_price: 8.50)
    ]
  end

  def test_total_is_zero_if_no_items_added
    co = Checkout.new(promotional_rules)

    assert_equal 0, co.total, 'Total is zero if no items added'
  end

  def test_no_promotions_apply
    co = Checkout.new(promotional_rules)
    co.scan(silk_dress)
    co.scan(silk_dress)
    price = co.total

    assert_equal 2*silk_dress.price, price.round(2), 'No promotions apply'
  end

  # Basket: 001, 002, 003
  # Total price expected: £66.78
  def test_total_spending_promotion
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silver_cufflinks)
    co.scan(silk_dress)
    price = co.total

    assert_equal 66.78, price.round(2), 'Applies TotalDiscount'
  end

  # Basket: 001, 003, 001
  # Total price expected: £36.95
  def test_item_quantity_promotion
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silk_dress)
    co.scan(red_scarf)
    price = co.total

    assert_equal 36.95, price.round(2), 'Applies ProductQuantityDiscount'
  end

  # Basket: 001, 002, 001, 003
  # Total price expected: £73.76
  def test_both_promotions_apply
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silver_cufflinks)
    co.scan(red_scarf)
    co.scan(silk_dress)
    price = co.total

    assert_equal 73.76, price.round(2), 'Applies ProductQuantityDiscount and then TotalDiscount'
  end
end
