# frozen_string_literal: true

class Intcode
  OPCODE_ADD = 1
  OPCODE_MUL = 2
  OPCODE_END = 99

  def initialize(memory)
    @memory = memory
    @instruction_pointer = 0
  end

  def run
    loop do
      break if end_of_program?

      a, b, x = parameters
      write(x, read(a).public_send(op, read(b)))
      jump_to_next_instruction!
    end
  end

  def read(address)
    @memory[address]
  end

  def write(address, value)
    @memory[address] = value
  end

  private

  def jump_to_next_instruction!
    @instruction_pointer += 4
  end

  def opcode
    @memory[@instruction_pointer]
  end

  def op
    case opcode
    when OPCODE_ADD then :+
    when OPCODE_MUL then :*
    end
  end

  def parameters
    @memory[@instruction_pointer + 1, 3]
  end

  def end_of_program?
    opcode == OPCODE_END
  end
end
