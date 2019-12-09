WIDTH = 25
HEIGHT = 6

layers = File.read('input.txt').chomp.chars.map(&:to_i).each_slice(WIDTH * HEIGHT)

layer_with_fewest_zeroes = layers.min_by { |data| data.count(0) }
puts layer_with_fewest_zeroes.count(1) * layer_with_fewest_zeroes.count(2)
