require 'set'
require_relative 'min_priority_queue'

module Graph
  INFINITY = 1.0 / 0.0 # positive infinity

  class AdjacencyGraph
    def self.[](*a)
      result = new
      a.each_slice(2) { |u, v| result.add_edge(u, v) }
      result
    end

    def initialize
      @vertices = {}
    end

    def each_adjacent(v, &b)
      @vertices[v].each(&b)
    end

    def add_edge(u, v)
      add_vertex(u)
      add_vertex(v)
      @vertices[u].add(v)
      @vertices[v].add(u)
    end

    def add_vertex(v)
      @vertices[v] ||= Set.new
    end

    def dijkstra_shortest_path(source, target)
      visitor = DijkstraVisitor.new(self)
      DijkstraAlgorithm.new(self, visitor).shortest_path(source, target)
    end
  end

  class PathBuilder
    def initialize(source, parents_map)
      @source      = source
      @parents_map = parents_map
      @paths       = {}
    end

    def path(target)
      @paths[target] ||= restore_path(target)
    end

    private

    def restore_path(target)
      return [@source] if target == @source

      parent = @parents_map[target]
      path(parent) + [target] if parent
    end
  end

  class DijkstraVisitor
    attr_reader :color_map
    attr_accessor :graph, :distance_map, :parents_map

    def initialize(graph)
      @graph = graph
      reset
    end

    def reset
      @color_map = Hash.new(:UNVISITED)
      @distance_map = Hash.new(INFINITY)
      @parents_map  = {}
    end

    def finished_vertex?(v)
      @color_map[v] == :FINISHED
    end

    def set_source(source)
      reset

      color_map[source]    = :WAITING
      distance_map[source] = 0
    end
  end

  class DijkstraAlgorithm
    def initialize(graph, visitor)
      @graph   = graph
      @visitor = visitor
    end

    def shortest_path(source, target)
      init(source)
      relax_edges(target)
      PathBuilder.new(source, @visitor.parents_map).path(target)
    end

    private

    def init(source)
      @visitor.set_source(source)

      @queue = MinPriorityQueue.new
      @queue.push(source, 0)
    end

    def relax_edges(target)
      until @queue.empty?
        u = @queue.pop

        break if u == target

        @graph.each_adjacent(u) do |v|
          relax_edge(u, v) unless @visitor.finished_vertex?(v)
        end

        @visitor.color_map[u] = :FINISHED
      end
    end

    def relax_edge(u, v)
      new_v_distance = @visitor.distance_map[u]

      if new_v_distance < @visitor.distance_map[v]
        @visitor.distance_map[v] = new_v_distance
        @visitor.parents_map[v]  = u

        if @visitor.color_map[v] == :UNVISITED
          @visitor.color_map[v] = :WAITING
          @queue.push(v, new_v_distance)
        elsif @visitor.color_map[v] == :WAITING
          @queue.decrease_key(v, new_v_distance)
        end
      end
    end
  end
end
