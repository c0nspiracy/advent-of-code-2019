# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)

computer = Intcode.new(memory, [2])
computer.run
computer.print_output
