# frozen_string_literal: true

class TotalCalculator
  def initialize(items, promotions)
    @items = items
    @promotions = promotions
  end

  def calculate
    promotions_in_processing_order.reduce(items) do |new_items, promotion|
      promotion.apply(new_items)
    end.total
  end

  private

  attr_reader :items, :promotions

  def promotions_in_processing_order
    promotions.select(&:applies_to_item?) + promotions.select(&:applies_to_total?)
  end
end
