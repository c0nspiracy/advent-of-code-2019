# frozen_string_literal: true

class HullPaintingRobot
  DIRECTIONS = %w[< ^ > v].freeze
  BLACK = 0
  WHITE = 1

  def initialize(starting_panel_colour = BLACK)
    @panels = Hash.new { |h, k| h[k] = BLACK }
    @x = 0
    @y = 0
    @direction = '^'
    paint(starting_panel_colour)
  end

  def panels_painted
    @panels.size
  end

  def colour
    @panels[[@x, @y]]
  end

  def paint(colour)
    @panels[[@x, @y]] = colour
  end

  def turn(left_or_right)
    current_direction = DIRECTIONS.index(@direction)
    delta = left_or_right.zero? ? -1 : 1
    @direction = DIRECTIONS[(current_direction + delta) % 4]
  end

  def move
    case @direction
    when '^' then @y -= 1
    when 'v' then @y += 1
    when '<' then @x -= 1
    when '>' then @x += 1
    end
  end

  def to_s
    width, height = @panels.keys.transpose.map(&:max)
    grid = Array.new(height + 1) { Array.new(width + 1, '..') }
    @panels.each { |(x, y), colour| grid[y][x] = '##' if colour == WHITE }
    grid.map(&:join).join("\n")
  end
end
