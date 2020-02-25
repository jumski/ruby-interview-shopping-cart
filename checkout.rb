# frozen_string_literal: true

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

