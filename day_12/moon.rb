# frozen_string_literal: true

class Moon
  attr_reader :x_position, :y_position, :z_position
  attr_reader :x_velocity, :y_velocity, :z_velocity

  def self.parse(data)
    match = data.match(/\A<x=(-?\d+), y=(-?\d+), z=(-?\d+)>\z/)
    raise ArgumentError, 'Invalid data' unless match

    x, y, z = match.captures.map(&:to_i)
    new(x, y, z)
  end

  def initialize(x_position, y_position, z_position)
    @x_position = x_position
    @y_position = y_position
    @z_position = z_position
    @x_velocity = 0
    @y_velocity = 0
    @z_velocity = 0
  end

  def x
    [x_position, @x_velocity]
  end

  def y
    [y_position, @y_velocity]
  end

  def z
    [z_position, @z_velocity]
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  def apply_gravity(other)
    @x_velocity += (other.x_position <=> x_position)
    @y_velocity += (other.y_position <=> y_position)
    @z_velocity += (other.z_position <=> z_position)
  end

  def apply_velocity
    @x_position += x_velocity
    @y_position += y_velocity
    @z_position += z_velocity
  end

  private

  def potential_energy
    [x_position, y_position, z_position].map(&:abs).sum
  end

  def kinetic_energy
    [x_velocity, y_velocity, z_velocity].map(&:abs).sum
  end
end
