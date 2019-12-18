# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
memory[0] = 2
program = "A,B,B,C,A,B,C,A,B,C\n"
a_pattern = "L,6,R,12,L,4,L,6\n"
b_pattern = "R,6,L,6,R,12\n"
c_pattern = "L,6,L,10,L,10,R,6\n"

computer = Intcode.new(memory)

computer.run_until { |output| output.chr == ':' }
computer << program.bytes

computer.run_until { |output| output.chr == ':' }
computer << a_pattern.bytes

computer.run_until { |output| output.chr == ':' }
computer << b_pattern.bytes

computer.run_until { |output| output.chr == ':' }
computer << c_pattern.bytes

computer.run_until { |output| output.chr == '?' }
computer << "n\n".bytes

computer.run_until { |output| output > 255 }
puts "Dust collected: #{computer.raw_output}"
