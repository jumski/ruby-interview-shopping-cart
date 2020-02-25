# frozen_string_literal: true

class Checkout
  def initialize(promotions)
    @promotions = promotions
  end

  def scan(item)
    items[item]+= 1
  end

  def total
    total_after_spending_promotions
  end

  private

  attr_reader :promotions

  def total_after_spending_promotions
    spending_promotions.reduce(total_after_item_promotions) do |total, promo|
      promo.apply(total)
    end
  end

  def total_after_item_promotions
    items_with_promotions.sum do |item, quantity|
      item.price * quantity
    end
  end

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

