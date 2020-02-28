# frozen_string_literal: true

class LineItems
  attr_reader :items

  def initialize(items = [])
    @items = Set.new(items)
  end

  def add(product)
    ensure_line_item!(product).tap do |line_item|
      line_item.increase_quantity
    end
  end

  def total
    items.sum(&:total)
  end

  def [](product_code)
    find_by_product_code(product_code)
  end

  def has_product?(product_code)
    !find_by_product_code(product_code).nil?
  end

  def map(&block)
    items.map(&block)
  end

  private

  def ensure_line_item!(product)
    find_by_product_code(product.code) || create_line_item!(product)
  end

  def create_line_item!(product)
    LineItem.new(product).tap do |line_item|
      items.add(line_item)
    end
  end

  def find_by_product_code(product_code)
    items.find{|li| li.product_code == product_code}
  end
end
