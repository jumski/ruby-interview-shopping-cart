# frozen_string_literal: true

require './total_calculator.rb'

class Checkout
  def initialize(promotions)
    @promotions = promotions
  end

  def scan(product)
    line_items.add(product)
  end

  def total
    TotalCalculator.new(line_items, promotions).calculate
  end

  private

  attr_reader :promotions

  def line_items
    @line_items ||= LineItems.new
  end
end

