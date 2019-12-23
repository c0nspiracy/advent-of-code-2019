# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
pulled = 0

(0...50).each do |y|
  (0...50).each do |x|
    computer = Intcode.new(memory.dup, [x, y])
    pulled += 1 if computer.run_and_return_output == 1
  end
end

puts pulled
