# frozen_string_literal: true

# Models a quantity of a named chemical
class Chemical
  attr_reader :quantity, :name

  def initialize(string)
    quantity, name = string.split
    @quantity = quantity.to_i
    @name = name
  end
end
