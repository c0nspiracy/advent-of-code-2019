# frozen_string_literal: true

require_relative 'reactor'

reaction_data = File.readlines('input.txt', chomp: true)
reactor = Reactor.new(reaction_data)

puts reactor.ore_cost(1, 'FUEL')
puts reactor.max_fuel_produceable_with(1_000_000_000_000)
