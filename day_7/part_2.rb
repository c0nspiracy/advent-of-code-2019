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
      left.run_until_next_output
      right << left.raw_output
    end

    last_comp = computers.last
    last_comp.run_until_next_output
    break if last_comp.halted?

    computers.first << last_comp.raw_output
  end

  computers.last.raw_output
end

puts res.max
