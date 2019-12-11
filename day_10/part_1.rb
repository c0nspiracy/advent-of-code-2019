# frozen_string_literal: true

require './monitoring_station.rb'

map = File.readlines('input.txt', chomp: true).map(&:chars)
puts MonitoringStation.new(map).asteroids_detectable_from_best_location
