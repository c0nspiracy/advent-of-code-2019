# frozen_string_literal: true

require './moon.rb'

moons = File.readlines('input.txt', chomp: true).map { |line| Moon.parse(line) }

1000.times do
  moons.combination(2) do |moon_a, moon_b|
    moon_a.apply_gravity(moon_b)
    moon_b.apply_gravity(moon_a)
  end
  moons.each(&:apply_velocity)
end

puts moons.sum(&:total_energy)
