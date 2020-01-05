# frozen_string_literal: true

require '../lib/intcode.rb'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)
computer = Intcode.new(memory)

loop do
  computer.run_interactive
  print ' '

  command = gets
  command = case command.chomp
            when 'n' then "north\n"
            when 'e' then "east\n"
            when 'w' then "west\n"
            when 's' then "south\n"
            else command
            end

  computer.provide_ascii_command(command)
end
