require_relative 'card'

class Deck
  def initialize
    @suits = %w[♠ ♥ ♦ ♣]
    @values = {
      '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8,
      '9': 9, '10': 10, J: 10, Q: 10, K: 10, A: [1, 11]
    }

    @card_deck = @default_deck = make_card_deck
    @used_cards = []
  end

  def hand_out_card
    taken_card = @card_deck.pop
    @used_cards << taken_card
    taken_card
  end

  def renew
    @card_deck = @default_deck
    @used_cards = []
    @card_deck.shuffle!
  end

  private

  def make_card_deck
    @suits.map do |suit|
      @values.map { |type, value| Card.new(value, suit, type) }
    end.flatten
  end
end
