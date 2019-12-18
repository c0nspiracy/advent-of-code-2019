num_phases = 100
part_2_multiplier = 10_000
signal = File.read('input.txt').chomp.chars.map(&:to_i)

def cumulative_sum(input)
  output = Array.new(input.length + 1, 0)
  input.each_with_index do |n, i|
    output[i + 1] = output[i] + n
  end

  output
end

def fft(scale, csum)
  i = scale
  sign = true
  out = 0

  while i < csum.length
    d = csum[[csum.length - 1, i + scale - 1].min] - csum[i - 1]

    if sign
      out += d
    else
      out -= d
    end
    sign = !sign
    i += scale * 2
  end

  out.abs % 10
end

input = signal.dup
num_phases.times do |n|
  csum = cumulative_sum(input)
  input = (0..input.length).map { |i| fft(i + 1, csum) }
end
puts "Part 1: #{input[0, 8].join}"

puts
input = signal.dup * part_2_multiplier
offset = signal[0, 7].join.to_i
num_phases.times do |n|
  puts "Phase #{n}"
  csum = cumulative_sum(input)
  input = (0..input.length).map { |i| fft(i + 1, csum) }
end
puts "Part 2: #{input[offset, 8].join}"
