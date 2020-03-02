# frozen_string_literal: true

class TotalCalculator
  def initialize(line_items, promotions)
    @line_items = line_items
    @promotions = promotions
  end

  def calculate
    line_items_with_promotions.total
  end

  private

  attr_reader :line_items, :promotions

  def line_items_with_promotions
    promotions_in_processing_order.reduce(line_items) do |items, promotion|
      promotion.apply(items)
    end
  end

  def promotions_in_processing_order
    promotions.select(&:applies_to_item?) + promotions.select(&:applies_to_total?)
  end
end
