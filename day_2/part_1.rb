# frozen_string_literal: true

require './intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)

computer = Intcode.new(memory)
computer.write(1, 12)
computer.write(2, 2)
computer.run

puts computer.read(0)
