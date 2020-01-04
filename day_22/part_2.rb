# frozen_string_literal: true

# Calculates large integer powers with the Exponentation by squaring method
# https://en.wikipedia.org/wiki/Exponentiation_by_squaring
def exp_by_squaring(a, b, exponent, deck_size)
  return [1, 0] if exponent.zero?

  if exponent.even?
    exp_by_squaring(a * a % deck_size, (a * b + b) % deck_size, exponent / 2, deck_size)
  else
    c, d = exp_by_squaring(a, b, exponent - 1, deck_size)
    [a * c % deck_size, (a * d + b) % deck_size]
  end
end

deck_size = 119_315_717_514_047
shuffles = 101_741_582_076_661
position = 2020
a = 1
b = 0

File.readlines('input.txt', chomp: true).reverse_each do |instruction|
  case instruction
  when /cut (-?\d+)/
    n = Regexp.last_match[1].to_i
    b = (b + n) % deck_size
  when /deal with increment (\d+)/
    n = Regexp.last_match[1].to_i
    z = n.pow(deck_size - 2, deck_size)
    a = a * z % deck_size
    b = b * z % deck_size
  when 'deal into new stack'
    a = -a
    b = deck_size - b - 1
  end
end

a, b = exp_by_squaring(a, b, shuffles, deck_size)
answer = (position * a + b) % deck_size

puts answer
