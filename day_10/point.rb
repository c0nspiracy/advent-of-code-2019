# frozen_string_literal: true

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def to_s
    "(#{x}, #{y})"
  end
  alias inspect to_s

  def distance_from(other)
    Math.hypot(x - other.x, y - other.y)
  end

  def gradient(other)
    dx = (x - other.x).abs
    dy = (y - other.y).abs
    if dy.zero?
      Float::INFINITY
    elsif dx.zero?
      0
    else
      Rational(dx, dy)
    end
  end

  def quadrant(other)
    if x >= other.x
      y <= other.y ? 0 : 1
    else
      y >= other.y ? 2 : 3
    end
  end
end
