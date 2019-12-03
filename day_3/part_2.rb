require 'scanf'

input = File.readlines('input.txt')
paths = input.map { |line| line.chomp.split(',') }

grid = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = {} } }

pos_y, pos_x = 0, 0
moves = {
  'U' => -> { pos_y += 1 },
  'D' => -> { pos_y -= 1 },
  'R' => -> { pos_x += 1 },
  'L' => -> { pos_x -= 1 }
}

paths.each_with_index do |path, wire|
  steps = 0

  path.each do |segment|
    direction, distance = segment.scanf('%c%d')

    distance.times do
      moves[direction].call
      steps += 1
      grid[pos_y][pos_x][wire] = steps
    end
  end

  pos_y, pos_x = 0, 0
end

coordinates = grid.flat_map { |y, row| [y].product(row.keys) }
intersection_points = coordinates.select { |y, x| grid[y][x].size == 2 }

puts intersection_points.map { |y, x| grid[y][x].map(&:last).reduce(:+) }.min
