# frozen_string_literal: true

DELTAS = [[0, -1], [0, 1], [-1, 0], [1, 0]].freeze

@maze = File.readlines('input.txt', chomp: true)

@start_positions = {}
@key_positions = {}
@key_to_key = {}

def parse_maze
  @maze.each_with_index do |line, y|
    line.each_char.with_index do |tile, x|
      if tile == '@'
        @start_positions["@#{@start_positions.count}"] = [x, y]
      elsif tile =~ /[a-z]/
        @key_positions[tile] = [x, y]
      end
    end
  end
end

def find_key_to_key_distances
  @key_positions.merge(@start_positions).each do |key, key_position|
    queue = [[*key_position, []]]
    distance = { key_position => 0 }
    keys = []
    until queue.empty?
      from_x, from_y, needed_keys = queue.shift

      DELTAS.each do |delta_x, delta_y|
        x = from_x + delta_x
        y = from_y + delta_y
        pos = [x, y]
        tile = @maze[y][x]
        next if tile == '#' || distance.key?(pos)

        distance[pos] = distance[[from_x, from_y]] + 1
        keys << [tile, needed_keys, distance[pos]] if tile =~ /[a-z]/

        queue << if tile =~ /[a-z]/i
                   [x, y, needed_keys + [tile.downcase]]
                 else
                   [x, y, needed_keys]
                 end
      end
    end

    @key_to_key[key] = keys
  end
end

def reachable_keys(positions, unlocked = [])
  [].tap do |keys|
    positions.each_with_index do |from_key, position_index|
      @key_to_key[from_key].each do |key, needed_keys, distance|
        next if unlocked.include?(key)
        next unless (needed_keys - unlocked).empty?

        keys << [position_index, key, distance]
      end
    end
  end
end

def min_steps(positions, unlocked = [], cache = {})
  cache_key = [positions.sort.join, unlocked.sort.join]

  cache.fetch(cache_key) do
    keys = reachable_keys(positions, unlocked)

    if keys.empty?
      val = 0
    else
      steps = []
      keys.each do |position_index, key, distance|
        original_position = positions[position_index]
        positions[position_index] = key
        steps << distance + min_steps(positions, unlocked + [key], cache)
        positions[position_index] = original_position
      end
      val = steps.min
    end

    cache[cache_key] = val
  end
end

parse_maze
find_key_to_key_distances
puts "Part 1: #{min_steps(@start_positions.keys)}"

sx, sy = @start_positions.values.first
@maze[sy - 1][sx - 1..sx + 1] = @maze[sy + 1][sx - 1..sx + 1] = '@#@'
@maze[sy][sx - 1..sx + 1] = '###'

parse_maze
find_key_to_key_distances
puts "Part 2: #{min_steps(@start_positions.keys)}"
