# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)

res = (5..9).to_a.permutation(5).to_a.map do |permutation|
  computers = permutation.map do |phase_setting|
    Intcode.new(memory.dup, [phase_setting])
  end

  # Set initial input
  computers.first << 0

  loop do
    computers.each_cons(2) do |left, right|
      right << left.run_and_return_output
    end

    last_comp = computers.last
    last_output = last_comp.run_and_return_output
    break last_output if last_comp.halted?

    computers.first << last_output
  end
end

puts res.max
