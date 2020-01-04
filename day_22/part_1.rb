# frozen_string_literal: true

class Deck
  def initialize(cards)
    @cards = cards
  end

  def self.factory_order(n = 10)
    new((0...n).to_a)
  end

  def index(n)
    @cards.index(n)
  end

  def deal_into_new_stack!
    @cards.reverse!
  end

  def cut_n_cards!(n)
    @cards.rotate!(n)
  end

  def deal_with_increment!(n)
    new_deck = Array.new(size)
    i = 0
    size.times do |j|
      new_deck[i] = @cards[j]
      i += n
      i %= size
    end
    @cards = new_deck
  end

  private

  def size
    @size ||= @cards.size
  end
end

deck = Deck.factory_order(10_007)

File.readlines('input.txt', chomp: true).each do |instruction|
  case instruction
  when /cut (-?\d+)/
    deck.cut_n_cards!(Regexp.last_match[1].to_i)
  when /deal with increment (\d+)/
    deck.deal_with_increment!(Regexp.last_match[1].to_i)
  when 'deal into new stack'
    deck.deal_into_new_stack!
  end
end

puts deck.index(2019)
