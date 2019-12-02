# frozen_string_literal: true

require './intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
possible_inputs = (0..99).to_a.repeated_permutation(2)
target_output = 19690720

noun, verb = possible_inputs.detect do |input_noun, input_verb|
  computer = Intcode.new(memory.dup)
  computer.write(1, input_noun)
  computer.write(2, input_verb)
  computer.run
  computer.read(0) == target_output
end

puts 100 * noun + verb
