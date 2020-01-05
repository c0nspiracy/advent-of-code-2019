# frozen_string_literal: true

require_relative 'graph'

input = File.readlines('input.txt', chomp: true)
orbits = input.flat_map { |line| line.split(')') }
graph = Graph::AdjacencyGraph[*orbits]
puts graph.dijkstra_shortest_path('YOU', 'SAN').count - 3
