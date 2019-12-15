# frozen_string_literal: true

require_relative 'chemical'

# Helper for parsing reaction data.
module Reaction
  module_function

  def parse(string)
    inputs, output = string.split(' => ')
    inputs = inputs.split(', ').map { |input| Chemical.new(input) }
    output = Chemical.new(output)

    [inputs, output]
  end
end
