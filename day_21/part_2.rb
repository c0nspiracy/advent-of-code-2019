# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

computer.run_until { |output| output.chr == ':' }

instructions = <<~SPRINGSCRIPT
  OR A J
  AND B J
  AND C J
  NOT J J
  AND D J
  OR E T
  OR H T
  AND T J
  RUN
SPRINGSCRIPT

ascii = instructions.split(/\r/).flat_map do |instruction|
  instruction.chars.map(&:ord)
end

computer << ascii
computer.run
puts computer.raw_output
