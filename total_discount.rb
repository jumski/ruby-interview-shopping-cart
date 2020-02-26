# frozen_string_literal: true

TotalDiscount = Struct.new(:threshold, :discount, keyword_init: true) do
  def applies_to_total?
    true
  end

  def applies_to_item?
    false
  end

  def apply(items)
    return items if items.total < threshold

    LineItemsDecorator.new(items, discount: discount)
  end

  class LineItemsDecorator < SimpleDelegator
    def initialize(items, discount:)
      super(items)
      @discount = discount
    end

    def total
      (1 - discount) * super
    end

    attr_reader :discount
  end
end

