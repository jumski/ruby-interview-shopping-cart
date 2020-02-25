# frozen_string_literal: true

class TotalCalculator
  def initialize(items, promotions)
    @items = items
    @promotions = promotions
  end

  def calculate
    apply_total_promotions(total_after_item_promotions)
  end

  private

  attr_reader :items, :promotions

  def apply_total_promotions(total)
    total_promotions.reduce(total) do |total, promo|
      promo.apply(total)
    end
  end

  def total_after_item_promotions
    items_with_promotions.sum do |item, quantity|
      item.price * quantity
    end
  end

  def total_promotions
    promotions.select(&:applies_to_total?)
  end

  def items_with_promotions
    items.map do |item, quantity|
      [decorate_with_promotions(item, quantity), quantity]
    end.to_h
  end

  def item_promotions
    promotions.select(&:applies_to_item?)
  end

  def decorate_with_promotions(item, quantity)
    item_promotions.reduce(item) do |new_item, promo|
      promo.apply(new_item, quantity)
    end
  end

end
