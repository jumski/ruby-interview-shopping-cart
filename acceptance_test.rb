# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'

Product = Struct.new(:code, :name, :price, keyword_init: true)

class AcceptanceTest < MiniTest::Unit::TestCase
  def red_scarf
    Product.new(code: '001', name: 'Red Scarf', price: 9.25),
  end

  def silver_cufflinks
    Product.new(code: '002', name: 'Silver cufflinks', price: 45.00),
  end

  def silk_dress
    Product.new(code: '003', name: 'Silk dress', price: 19.95)
  end

  def promotional_rules
    [
      TotalDiscount.new(threshold: 60.00, discount: 0.1),
      ProductQuantityDiscount.new(product_code: red_scarf.code, min_quantity: 2, new_price: 8.50)
    ]
  end

  # Basket: 001, 002, 003
  # Total price expected: £66.78
  def test_every_item_once
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silver_cufflinks)
    co.scan(silk_dress)
    price = co.total

    assert_equal price, 66.78, 'Applies TotalDiscount'
  end

  # Basket: 001, 003, 001
  # Total price expected: £36.95

  # Basket: 001, 002, 001, 003
  # Total price expected: £73.76

    # assert !Quotes.new.weekly(Date.parse('1970-01-01')).nil?
    # assert_equal quotes.weekly, quotes.weekly(Date.today)
    #   assert !quotes.weekly(date).nil?, "Works for #{date}"
    # assert !quotes.weekly(Date.parse('2100-01-01')).nil?
    #   assert quote_a != quote_b, "Week #{week_a} and #{week_b} should have different quotes"
    # assert_equal index_for_old_year + 1, index_for_new_year
    # assert quotes.weekly(sunday_week1) != quotes.weekly(monday_week2)
end
