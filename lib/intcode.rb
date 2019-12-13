# frozen_string_literal: true

class Intcode
  OPCODE_END = 99
  OPCODES = {
    1 => :add,
    2 => :multiply,
    3 => :input,
    4 => :output,
    5 => :jump_if_true,
    6 => :jump_if_false,
    7 => :less_than,
    8 => :equals,
    9 => :adjust_relative_base
  }

  def initialize(memory, input = [])
    @memory = memory
    @instruction_pointer = 0
    @input = input
    @output = []
    @relative_base = 0
  end

  def run
    loop do
      decode_instruction
      break if halted?

      execute_instruction
    end
  end

  def run_and_return_output(n = 1)
    starting_output_size = @output.size

    loop do
      decode_instruction
      break if halted?

      execute_instruction
      break if @output.size >= starting_output_size + n
    end

    n == 1 ? @output.last : @output.last(n)
  end

  def print_output
    if @output.length == 1 || @output[0...-1].all?(&:zero?)
      puts "SUCCESS"
      puts "Diagnostic code: #{@output.last}"
    else
      puts "ERROR"
      puts "Test results: #{@output}"
    end
  end

  def raw_output
    @output.last
  end

  def <<(input)
    @input << input
  end

  def read(address)
    raise "Can't read memory at a negative address" if address.negative?
    @memory[address] || 0
  end

  def write(address, value)
    @memory[address] = value
  end

  def halted?
    opcode == OPCODE_END
  end

  private

  attr_reader :opcode

  def decode_instruction
    @opcode, *@parameter_modes = immediate_mode? ? decode_immediate_mode_instruction : decode_position_mode_instruction
  end

  def immediate_mode?
    instruction.digits.size > 2
  end

  def decode_position_mode_instruction
    [instruction, 0, 0, 0]
  end

  def decode_immediate_mode_instruction
    instruction.to_s.rjust(5, '0').split(//, 4).map(&:to_i).reverse
  end

  def execute_instruction
    operation = method(:"op_#{OPCODES[opcode]}")
    operation.call(*parameters_for(operation))
  end

  def parameters_for(method)
    addresses = @memory[@instruction_pointer + 1, method.arity]
    params_for_writing = method.parameters.map { |_, p| p == :x }
    addresses.map.with_index do |address, index|
      case @parameter_modes[index]
      when 0
        params_for_writing[index] ? address : read(address)
      when 1
        address
      when 2
        new_address = @relative_base + address
        params_for_writing[index] ? new_address : read(new_address)
      end
    end
  end

  def op_add(a, b, x)
    write(x, a + b)
    @instruction_pointer += 4
  end

  def op_multiply(a, b, x)
    write(x, a * b)
    @instruction_pointer += 4
  end

  def op_input(x)
    write(x, @input.shift)
    @instruction_pointer += 2
  end

  def op_output(a)
    @output << a
    @instruction_pointer += 2
  end

  def op_jump_if_true(a, b)
    if a.nonzero?
      @instruction_pointer = b
    else
      @instruction_pointer += 3
    end
  end

  def op_jump_if_false(a, b)
    if a.zero?
      @instruction_pointer = b
    else
      @instruction_pointer += 3
    end
  end

  def op_less_than(a, b, x)
    write(x, a < b ? 1 : 0)
    @instruction_pointer += 4
  end

  def op_equals(a, b, x)
    write(x, a == b ? 1 : 0)
    @instruction_pointer += 4
  end

  def op_adjust_relative_base(a)
    @relative_base += a
    @instruction_pointer += 2
  end

  def instruction
    @memory[@instruction_pointer]
  end
end
