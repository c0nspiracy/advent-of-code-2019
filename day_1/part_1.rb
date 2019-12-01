# frozen_string_literal: true

# To find the fuel required for a module, take its mass, divide by
# three, round down, and subtract 2.
def fuel_required(mass)
  mass.fdiv(3).floor - 2
end

modules = File.readlines('input.txt').map(&:chomp).map(&:to_i)
total = modules.sum { |mass| fuel_required(mass) }

puts total
