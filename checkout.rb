# frozen_string_literal: true

require './total_calculator.rb'

class Checkout
  def initialize(promotions)
    @promotions = promotions
  end

  def scan(item)
    items[item]+= 1
  end

  def total
    TotalCalculator.new(items, promotions).calculate
  end

  private

  attr_reader :promotions

  def items
    @items ||= Hash.new(0)
  end
end

