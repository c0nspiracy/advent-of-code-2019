# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

block_tile_count = 0
loop do
  _x, _y, tile_id = computer.run_and_return_output(3)
  block_tile_count += 1 if tile_id == 2

  break if computer.halted?
end

puts block_tile_count
