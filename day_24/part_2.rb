# frozen_string_literal: true

def empty_grid
  Array.new(5) { Array.new(5, '.') }.tap do |grid|
    grid[2][2] = '?'
  end
end

def bug_count(grids)
  grids.values.sum { |grid| grid.flatten.count('#') }
end

grids = Hash.new { |h, k| h[k] = empty_grid }
adjacency = Hash.new { |h, k| h[k] = Array.new(5) { [0, 0, 0, 0, 0] } }

input_grid = File.readlines('input.txt', chomp: true).map(&:chars)
input_grid[2][2] = '?'
grids[-1]
grids[0] = input_grid
grids[1]
generation = 0

while generation < 200
  current_depths = grids.keys
  current_depths.each do |depth|
    grid = grids[depth]
    grid.each_with_index do |row, y|
      row.each_index do |x|
        next if y == 2 && x == 2

        adjacent = 0

        if x.positive?
          adjacent += case row[x - 1]
                      when '#' then 1
                      when '?' then grids[depth + 1].transpose.last.count('#')
                      else 0
                      end
        else
          adjacent += grids[depth - 1][2][1] == '#' ? 1 : 0
        end

        if x < 4
          adjacent += case row[x + 1]
                      when '#' then 1
                      when '?' then grids[depth + 1].transpose.first.count('#')
                      else 0
                      end
        else
          adjacent += grids[depth - 1][2][3] == '#' ? 1 : 0
        end

        if y.positive?
          adjacent += case grid[y - 1][x]
                      when '#' then 1
                      when '?' then grids[depth + 1].last.count('#')
                      else 0
                      end
        else
          adjacent += grids[depth - 1][1][2] == '#' ? 1 : 0
        end

        if y < 4
          adjacent += case grid[y + 1][x]
                      when '#' then 1
                      when '?' then grids[depth + 1].first.count('#')
                      else 0
                      end
        else
          adjacent += grids[depth - 1][3][2] == '#' ? 1 : 0
        end

        adjacency[depth][y][x] = adjacent
      end
    end
  end

  grids.each do |depth, grid|
    grid.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        adjacent = adjacency[depth][y][x]
        row[x] = '.' if tile == '#' && adjacent != 1
        row[x] = '#' if tile == '.' && (1..2).include?(adjacent)
      end
    end
  end

  generation += 1
end

puts bug_count(grids)
