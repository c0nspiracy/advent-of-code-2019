class Orbits
  attr_reader :direct_orbits, :indirect_orbits

  def initialize(orbits)
    @orbits = orbits
    @direct_orbits = 0
    @indirect_orbits = 0
  end

  def decend(object = 'COM', depth = 0)
    return unless @orbits.key?(object)

    @orbits[object].each do |orbiter|
      @direct_orbits += 1
      @indirect_orbits += depth
      decend(orbiter, depth + 1)
    end
  end
end

lines = File.readlines('input.txt', chomp: true)

orbits = Hash.new { |h, k| h[k] = [] }

lines.each do |line|
  a, b = line.split(')')
  orbits[a] << b
end

obj = Orbits.new(orbits)
obj.decend
puts obj.direct_orbits + obj.indirect_orbits
