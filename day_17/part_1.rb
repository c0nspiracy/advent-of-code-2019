# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

current_view = computer.run_and_return_all_output.map(&:chr).join.split.map(&:chars)

def find_intersections(view)
  intersections = []
  view[1...-1].each.with_index(1) do |line, y|
    line[1...-1].each.with_index(1) do |cell, x|
      next unless cell == '#'
      neighbours = [
        view[y - 1][x],
        view[y + 1][x],
        view[y][x - 1],
        view[y][x + 1]
      ]
      intersections << [y, x] if neighbours.all? { |c| c == '#' }
    end
  end
  intersections
end

intersections = find_intersections(current_view)
alignment_parameters = intersections.map { |y, x| y * x }
puts alignment_parameters.sum
