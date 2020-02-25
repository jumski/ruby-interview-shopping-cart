# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'

Product = Struct.new(:code, :name, :price, keyword_init: true)

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

TotalDiscount = Struct.new(:threshold, :discount, keyword_init: true) do
  def applies_to_total?
    true
  end

  def applies_to_item?
    false
  end

  def applies?(total)
    total >= threshold
  end

  def apply(total)
    return total unless applies?(total)

    (1 - discount) * total
  end
end

class Checkout
  def initialize(promotions)
    @promotions = promotions
  end

  def scan(item)
    items[item]+= 1
  end

  def total
    base_total = items_with_promotions.sum do |item, quantity|
      item.price * quantity
    end

    total_with_discount = spending_promotions.reduce(base_total) do |total, promo|
      promo.apply(total)
    end

    total_with_discount
  end

  private

  attr_reader :promotions

  def spending_promotions
    promotions.select(&:applies_to_total?)
  end

  def items_with_promotions
    items.map do |item, quantity|
      [decorate_with_promotions(item, quantity), quantity]
    end.to_h
  end

  def decorate_with_promotions(item, quantity)
    promotions.select(&:applies_to_item?).reduce(item) do |new_item, promo|
      promo.apply(new_item, quantity)
    end
  end

  def items
    @items ||= Hash.new(0)
  end
end

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

  # Basket: 001, 002, 003
  # Total price expected: £66.78
  def test_total_spending_promotion
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silver_cufflinks)
    co.scan(silk_dress)
    price = co.total

    assert_equal price, 66.78, 'Applies TotalDiscount'
  end

  # Basket: 001, 003, 001
  # Total price expected: £36.95
  def test_item_quantity_promotion
    co = Checkout.new(promotional_rules)
    co.scan(red_scarf)
    co.scan(silk_dress)
    co.scan(red_scarf)
    price = co.total

    assert_equal price, 36.95, 'Applies ProductQuantityDiscount'
  end

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
