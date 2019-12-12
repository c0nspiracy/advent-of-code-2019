# frozen_string_literal: true

require './moon.rb'

moons = File.readlines('input.txt', chomp: true).map { |line| Moon.parse(line) }

steps = 0
initial_state = {
  x: moons.map(&:x),
  y: moons.map(&:y),
  z: moons.map(&:z)
}
cycles = {
  x: 0,
  y: 0,
  z: 0
}

loop do
  moons.combination(2) do |moon_a, moon_b|
    moon_a.apply_gravity(moon_b)
    moon_b.apply_gravity(moon_a)
  end
  moons.each(&:apply_velocity)
  steps += 1

  cycles.each_key do |axis|
    next if cycles[axis].nonzero?

    cycles[axis] = steps if moons.map(&axis) == initial_state[axis]
  end

  break if cycles.values.all?(&:nonzero?)
end

puts cycles.values.reduce(:lcm)
