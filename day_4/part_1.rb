input = File.read('input.txt').chomp.split('-')
range = Range.new(*input.map(&:to_i))

different_passwords = range.count do |n|
  pairs = n.digits.each_cons(2)
  pairs.any? { |a, b| a == b } && pairs.all? { |a, b| a >= b }
end

puts different_passwords
