WIDTH = 25
HEIGHT = 6

class Layer
  attr_reader :pixels

  def self.to_proc
    ->(arg) { new(arg) }
  end

  def initialize(pixels)
    @pixels = pixels
  end

  def merge(other_layer)
    Layer.new(pixels.zip(other_layer).map { |p, q| p.merge(q) })
  end

  def to_ary
    pixels
  end

  def to_s
    pixels.each_slice(WIDTH).map(&:join)
  end
end

class Pixel
  BLACK = 0
  WHITE = 1
  TRANSPARENT = 2
  
  def self.to_proc
    ->(arg) { new(arg) }
  end

  def initialize(color)
    @color = color.to_i
  end

  def merge(other_pixel)
    @color == TRANSPARENT ? other_pixel : self
  end

  def to_s
    case @color
    when BLACK then '..'
    when WHITE then '@@'
    when TRANSPARENT then '  '
    end
  end
end

puts File.read('input.txt').chomp.chars.map(&Pixel).each_slice(WIDTH * HEIGHT).map(&Layer).inject(&:merge).to_s
