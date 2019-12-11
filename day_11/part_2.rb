# frozen_string_literal: true

require '../lib/intcode.rb'
require './hull_painting_robot.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)
robot = HullPaintingRobot.new(HullPaintingRobot::WHITE)

loop do
  computer << robot.colour

  computer.run_until_next_output
  robot.paint(computer.raw_output)

  computer.run_until_next_output
  robot.turn(computer.raw_output)
  robot.move

  break if computer.halted?
end

puts robot
