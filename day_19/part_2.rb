# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
beam_data = [[0, 0]]
y = -1
square_size = 100
min_y = square_size / 2
min_x = square_size / 0.66

loop do
  y += 1
  beam_positions = []

  left_x, right_x = beam_data.last
  if right_x - left_x >= 2
    left_edge = ((y * left_x.fdiv(y - 1)) - 0.5).round
    right_edge = ((y * right_x.fdiv(y - 1)) + 0.5).round
  else
    left_edge = [0, left_x - 1].max
    right_edge = right_x + 1
  end

  (left_edge..right_edge).each do |x|
    next if x > left_edge + 1 && x < right_edge - 1

    computer = Intcode.new(memory.dup, [x, y])
    beam_positions << x if computer.run_and_return_output == 1
  end

  bottom_left, bottom_right = beam_positions.minmax
  beam_data << [bottom_left || y, bottom_right || y]

  next unless y >= min_y
  next unless bottom_right - bottom_left > min_x

  top_left, top_right = beam_data[-square_size]
  next unless top_left <= bottom_left && (bottom_left + square_size - 1) == top_right

  answer = (bottom_left * 10_000) + (y - square_size + 1)
  puts answer
  break
end
