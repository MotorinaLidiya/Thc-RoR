require_relative 'bank'
require_relative 'deck'
require_relative 'card'

class Player
  attr_accessor :cards, :deck
  attr_reader :balance, :name

  def initialize(name, deck)
    @name = name
    @bank = Bank.new
    @cards = []
    @deck = deck
  end

  def take_card
    return 'Добрано максимальное количество карт. ' if cards.size == 3

    card = @deck.hand_out_card
    cards << card
  end

  def player_make_bet
    @bank.make_bet
  end

  def player_return_bet
    @bank.return_bet
  end

  def player_win_bet
    @bank.win_bet
  end

  def show_hand
    cards.map(&:to_s).join(', ')
  end

  def show_balance
    @bank.balance
  end

  def check_cards_value
    values = cards.map(&:value)
    return cards.sum(&:value) unless contains_subarrays?(values)

    ace_array = [1, 11]
    sum_with_ace(ace_array, values)
  end

  private

  def sum_with_ace(array, values)
    count = values.count(array)
    values.delete(array)

    sum = values.sum + array[1] * count
    while sum > 21 && count.positive?
      sum -= 10
      count -= 1
    end

    sum
  end

  def contains_subarrays?(array)
    array.any? { |element| element.is_a?(Array) }
  end
end
