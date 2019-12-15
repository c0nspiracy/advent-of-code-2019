# frozen_string_literal: true

require_relative 'reaction'

class Reactor
  attr_accessor :reactions

  def initialize(reaction_data)
    @reactions = {}
    reaction_data.each do |reaction_line|
      inputs, output = Reaction.parse(reaction_line)
      @reactions[output.name] = [output.quantity, inputs]
    end
  end

  def ore_cost(quantity, name, needed = Hash.new(0), excess = Hash.new(0))
    reaction_quantity, inputs = @reactions[name]
    if quantity < excess[name]
      excess[name] -= quantity
    else
      multiplier = [(quantity - excess[name]).fdiv(reaction_quantity).ceil, 0].max
      needed[name] -= excess[name]
      excess[name] = multiplier * reaction_quantity - needed[name] if name != 'FUEL'
      inputs.each do |input|
        needed[input.name] += multiplier * input.quantity
        ore_cost(input.quantity * multiplier, input.name, needed, excess) if input.name != 'ORE'
      end
    end
    needed[name] = 0
    needed['ORE']
  end

  def max_fuel_produceable_with(ore)
    (1..ore).bsearch { |i| ore_cost(i, 'FUEL') > ore } - 1
  end
end
