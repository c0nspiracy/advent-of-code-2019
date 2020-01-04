# frozen_string_literal: true

require '../lib/intcode.rb'
require 'set'

memory = File.read('input.txt').chomp.split(',').map(&:to_i)

input_queue = (0..49).map { [] }
computers = (0..49).each_with_object({}) do |address, memo|
  computer = Intcode.new(memory.dup)
  computer.provide_input(address)
  memo[address] = computer
end

nat_x = nil
nat_y = nil
nat_ys = Set.new

loop do
  all_idle = computers.all? do |addr, computer|
    input_queue[addr].empty? && computer.output_size.zero?
  end

  if all_idle
    if nat_ys.include?(nat_y)
      puts "Part 2: #{nat_y}"
      exit
    end
    nat_ys << nat_y
    input_queue[0] << nat_x << nat_y
  end

  computers.each do |addr, computer|
    if computer.output_size >= 3
      dest, x, y = computer.next_output(3)

      if dest == 255
        puts "Part 1: #{y}" if nat_y.nil?
        nat_x = x
        nat_y = y
      elsif computers.key?(dest)
        input_queue[dest] << x << y
      end
    end

    computer.provide_input(input_queue[addr].shift || -1)
  end
end
