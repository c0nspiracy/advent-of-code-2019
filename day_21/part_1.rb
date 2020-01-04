# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

computer.run_until { |output| output.chr == ':' }

instructions = <<~SPRINGSCRIPT
  NOT A T
  NOT C J
  OR T J
  AND D J
  WALK
SPRINGSCRIPT

ascii = instructions.split(/\r/).flat_map do |instruction|
  instruction.chars.map(&:ord)
end

computer << ascii
computer.run
puts computer.raw_output
