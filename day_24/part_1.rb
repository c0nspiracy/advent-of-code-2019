# frozen_string_literal: true

require 'set'

def calculate_rating(grid)
  grid.flatten.each_with_index.reduce(0) do |sum, (tile, n)|
    tile == '#' ? sum + 2**n : sum
  end
end

ratings = Set.new
grid = File.readlines('input.txt', chomp: true).map(&:chars)
adjacency = Array.new(grid.size) { [] }
rating = nil

loop do
  grid.each_with_index do |row, y|
    row.each_index do |x|
      adjacent = 0
      adjacent += 1 if x.positive? && row[x - 1] == '#'
      adjacent += 1 if x < row.size - 1 && row[x + 1] == '#'
      adjacent += 1 if y.positive? && grid[y - 1][x] == '#'
      adjacent += 1 if y < grid.size - 1 && grid[y + 1][x] == '#'

      adjacency[y][x] = adjacent
    end
  end

  grid.each_with_index do |row, y|
    row.each_with_index do |tile, x|
      grid[y][x] = '.' if tile == '#' && adjacency[y][x] != 1
      grid[y][x] = '#' if tile == '.' && (1..2).include?(adjacency[y][x])
    end
  end

  rating = calculate_rating(grid)
  break if ratings.include?(rating)

  ratings << rating
end

puts rating
