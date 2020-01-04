# frozen_string_literal: true

DELTAS = [[0, -1], [0, 1], [-1, 0], [1, 0]].freeze

@maze = File.readlines('input.txt', chomp: true)
@start_position = []
@end_position = []
@portals = Hash.new { |h, k| h[k] = [] }
@paths = {}

def parse_maze
  tmaze = @maze.map(&:chars).transpose.map(&:join)

  @maze.each_with_index do |line, y|
    line.each_char.with_index do |tile, x|
      next unless tile == '.'

      labels = [-2, 1].flat_map do |d|
        [[tmaze[x][y + d, 2], :v], [line[x + d, 2], :h]]
      end
      portal, direction = labels.detect { |label, _d| label.match?(/[A-Z]{2}/) }
      next unless portal

      case portal
      when 'AA'
        @start_position = [x, y]
      when 'ZZ'
        @end_position = [x, y]
      else
        level_delta = case direction
                      when :h
                        [2, line.length - 3].include?(x) ? 1 : -1
                      when :v
                        [2, @maze.length - 3].include?(y) ? 1 : -1
                      end
        @portals[portal] << [x, y, level_delta]
      end
    end
  end
end

def build_pmap
  @pmap = {}
  @portals.values.each do |(a, b)|
    @pmap[a[0..1]] = b
    @pmap[b[0..1]] = a
  end
end

def find_portal_to_portal_distances
  ([@start_position] + @pmap.keys).each do |base|
    queue = [base]
    distance = { base => 0 }
    paths = {}

    until queue.empty?
      from = queue.shift
      from_x, from_y, _level = from

      DELTAS.each do |delta_x, delta_y|
        x = from_x + delta_x
        y = from_y + delta_y
        tile = @maze[y][x]
        next if tile != '.'

        to = [x, y]
        next if distance.key?(to)

        distance[to] = distance[from] + 1
        if to == @end_position
          paths[@end_position] = distance[to]
        elsif @pmap.key?(to)
          p_x, p_y, p_delta = @pmap[to]
          paths[[p_x, p_y]] = [distance[to] + 1, p_delta]
        else
          queue << to
        end
      end
    end

    @paths[base] = paths
  end
end

def shortest_path(recursive)
  queue = [[@start_position, 0]]
  distance = { queue.first => 0 }

  until queue.empty?
    from = queue.shift

    from_point, from_level = from
    paths = @paths[from_point]
    return distance[from] + paths[@end_position] if paths.key?(@end_position) && from_level.zero?

    paths.each do |point, (p_dist, p_delta)|
      next if point == @end_position

      to_level = recursive ? from_level + p_delta : 0
      next if to_level.negative?

      to = [point, to_level]
      next if distance.key?(to)

      distance[to] = distance[from] + p_dist
      queue << to
    end
  end
end

parse_maze
build_pmap
find_portal_to_portal_distances

puts "Part 1: #{shortest_path(false)}"
puts "Part 2: #{shortest_path(true)}"
