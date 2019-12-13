# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
memory[0] = 2
computer = Intcode.new(memory)

score = 0
ball_direction = 0
ball_location = 0
paddle_location = 0

loop do
  break if computer.halted?

  x, y, tile_id = computer.run_and_return_output(3)

  if x == -1 && y == 0
    score = tile_id
    next
  end

  paddle_location = x if tile_id == 3

  if tile_id == 4
    ball_direction = x - ball_location
    ball_location = x

    input = if ball_direction == 1 && ball_location > paddle_location
              1
            elsif ball_direction == -1 && ball_location < paddle_location
              -1
            else
              0
            end

    computer << input
  end
end

puts score
