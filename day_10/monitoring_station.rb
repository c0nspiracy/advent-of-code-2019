# frozen_string_literal: true

require 'set'
require './point.rb'

class MonitoringStation
  def initialize(asteroid_map)
    @asteroid_map = asteroid_map
  end

  def asteroids_detectable_from_best_location
    asteroid_locations.map { |point| number_of_asteroids_visible_from(point) }.max
  end

  def best_location
    asteroid_locations.max_by { |point| number_of_asteroids_visible_from(point) }
  end

  def nth_asteroid_to_be_vaporized_from(location, n)
    vaporized = 0

    loop do
      asteroids = asteroids_visible_from(location)
      break if asteroids.empty?

      asteroids.each do |asteroid|
        vaporize!(asteroid)
        vaporized += 1

        return asteroid if vaporized == n
      end
    end
  end

  private

  def number_of_asteroids_visible_from(origin_point)
    asteroid_locations.each_with_object(Set.new) do |asteroid, set|
      next if origin_point == asteroid

      quadrant = asteroid.quadrant(origin_point)
      gradient = asteroid.gradient(origin_point)
      set << [quadrant, gradient]
    end.count
  end

  def asteroids_visible_from(origin_point)
    visible = asteroid_locations.each_with_object(Hash.new) do |asteroid, hash|
      next if origin_point == asteroid

      quadrant = asteroid.quadrant(origin_point)
      gradient = asteroid.gradient(origin_point)
      gradient = -gradient if [1, 3].include?(quadrant)

      key = [quadrant, gradient]
      hash[key] = [hash[key], asteroid].compact.min_by { |a| a.distance_from(origin_point).abs }
    end

    visible.sort.map(&:last)
  end

  def vaporize!(asteroid)
    asteroid_locations.delete(asteroid)
  end

  def asteroid_locations
    @asteroid_locations ||= [].tap do |locations|
      @asteroid_map.each_with_index do |row, y|
        row.each_with_index do |location, x|
          locations << Point.new(x, y) if location == '#'
        end
      end
    end
  end
end
