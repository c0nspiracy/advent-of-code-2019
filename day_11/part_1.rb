# frozen_string_literal: true

require '../lib/intcode.rb'
require './hull_painting_robot.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)
robot = HullPaintingRobot.new

loop do
  computer << robot.colour

  robot.paint(computer.run_and_return_output)
  robot.turn(computer.run_and_return_output)
  robot.move

  break if computer.halted?
end

puts robot.panels_painted
