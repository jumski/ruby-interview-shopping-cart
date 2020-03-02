# frozen_string_literal: true

Product = Struct.new(:code, :name, :price, keyword_init: true) do
  def hash
    code.hash
  end
end

