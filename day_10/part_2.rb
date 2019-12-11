# frozen_string_literal: true

require './monitoring_station.rb'

map = File.readlines('input.txt', chomp: true).map(&:chars)
monitoring_station = MonitoringStation.new(map)
location = monitoring_station.best_location
asteroid = monitoring_station.nth_asteroid_to_be_vaporized_from(location, 200)

puts (asteroid.x * 100) + asteroid.y
