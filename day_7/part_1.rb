# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)

res = (0..4).to_a.permutation(5).to_a.map do |permutation|
  permutation.inject(0) do |input, phase_setting|
    computer = Intcode.new(memory.dup, [phase_setting, input])
    computer.run
    computer.raw_output
  end
end
puts res.max
