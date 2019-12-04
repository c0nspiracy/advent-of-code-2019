input = File.read('input.txt').chomp.split('-')
range = Range.new(*input.map(&:to_i))

different_passwords = range.count do |n|
  digits = n.digits
  pairs = digits.each_cons(2)
  repeated_digit_counts = digits.uniq.map { |d| digits.count(d) }
  pairs.all? { |a, b| a >= b } && repeated_digit_counts.include?(2)
end

puts different_passwords
