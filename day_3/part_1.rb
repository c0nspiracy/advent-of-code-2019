require 'scanf'
require 'set'

input = File.readlines('input.txt')
paths = input.map { |line| line.chomp.split(',') }

grid = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = Set.new } }

pos_y, pos_x = 0, 0
moves = {
  'U' => -> { pos_y += 1 },
  'D' => -> { pos_y -= 1 },
  'R' => -> { pos_x += 1 },
  'L' => -> { pos_x -= 1 }
}

paths.each_with_index do |path, wire|
  path.each do |segment|
    direction, distance = segment.scanf('%c%d')

    distance.times do
      moves[direction].call
      grid[pos_y][pos_x] << wire
    end
  end

  pos_y, pos_x = 0, 0
end

coordinates = grid.flat_map { |y, row| [y].product(row.keys) }
intersection_points = coordinates.select { |y, x| grid[y][x].size == 2 }

puts intersection_points.map { |point| point.map(&:abs).reduce(:+) }.min
