# frozen_string_literal: true

TotalDiscount = Struct.new(:threshold, :discount, keyword_init: true) do
  def applies_to_total?
    true
  end

  def applies_to_item?
    false
  end

  def applies?(total)
    total >= threshold
  end

  def apply(total)
    return total unless applies?(total)

    (1 - discount) * total
  end
end

