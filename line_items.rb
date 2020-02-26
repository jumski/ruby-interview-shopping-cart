# frozen_string_literal: true

class LineItems
  attr_reader :line_items

  def initialize(line_items = [])
    @line_items = Set.new(line_items)
  end

  def add(product)
    ensure_line_item_for(product)

    line_item = find_by_product_code(product.code)
    line_item.increase_quantity
  end

  def total
    line_items.sum(&:total)
  end

  def [](product_code)
    find_by_product_code(product_code)
  end

  def has_product?(product_code)
    !find_by_product_code(product_code).nil?
  end

  def map(&block)
    line_items.map(&block)
  end

  private

  def ensure_line_item_for(product)
    line_items.add LineItem.new(product)
  end

  def find_by_product_code(product_code)
    line_items.find{|li| li.product_code == product_code}
  end
end
