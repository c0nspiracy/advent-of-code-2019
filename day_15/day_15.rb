# frozen_string_literal: true

require_relative '../lib/intcode'
require_relative '../lib/grid'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

NEIGHBOURS = {
  north: [-1, 0],
  south: [1, 0],
  west: [0, -1],
  east: [0, 1]
}.freeze
DELTAS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze
OPPOSITE = [1, 0, 3, 2].freeze
WALL = '#'

def calculate_offset(locations)
  min_y, min_x = locations.keys.transpose.map(&:min)
  offset_y = -min_y
  offset_x = -min_x

  [offset_y, offset_x]
end

def normalize_locations(locations, offset_y, offset_x)
  locations.transform_keys { |y, x| [y + offset_y, x + offset_x] }
end

def generate_grid(locations)
  max_y, max_x = locations.keys.transpose.flat_map(&:max)

  Grid.new(max_y + 1, max_x + 1).tap do |grid|
    grid.each_cell do |cell|
      link_neighbouring_cells(locations, cell)
    end
  end
end

def link_neighbouring_cells(locations, cell)
  cell_y = cell.row
  cell_x = cell.column
  return unless locations[[cell_y, cell_x]] == '.'

  NEIGHBOURS.each do |direction, (dy, dx)|
    if (ncell = cell.public_send(direction))
      cell.link(ncell) if locations[[cell_y + dy, cell_x + dx]] == '.'
    end
  end
end

locations = Hash.new { |h, k| h[k] = ' ' }
backtrack = Hash.new { |h, k| h[k] = [0, 1, 2, 3] }
x = 0
y = 0
oxygen_x = 0
oxygen_y = 0
locations[[y, x]] = '.'

iterations_without_discoveries = 0
previous_key_count = 0

loop do
  input = backtrack[[y, x]].shift
  computer << input + 1

  status_code = computer.run_and_return_output

  dy, dx = DELTAS[input]
  new_y = y + dy
  new_x = x + dx

  unless status_code.zero?
    backtrack[[y, x]] << input
    y = new_y
    x = new_x
    opposite_input = OPPOSITE[input]
    backtrack[[y, x]] -= [opposite_input]
    backtrack[[y, x]] << opposite_input
  end

  if status_code == 2
    oxygen_y = y
    oxygen_x = x
  end

  locations[[new_y, new_x]] = status_code.zero? ? WALL : '.'

  if previous_key_count == locations.keys.count
    iterations_without_discoveries += 1
  else
    iterations_without_discoveries = 0
  end

  break if iterations_without_discoveries > 100

  previous_key_count = locations.keys.count
end

offset_y, offset_x = calculate_offset(locations)
normalized_locations = normalize_locations(locations, offset_y, offset_x)

grid = generate_grid(normalized_locations)

start_location = grid[offset_y, offset_x]
oxygen_location = grid[oxygen_y + offset_y, oxygen_x + offset_x]

puts "Part 1: #{start_location.distances[oxygen_location]}"
puts "Part 2: #{oxygen_location.distances.max.last}"
