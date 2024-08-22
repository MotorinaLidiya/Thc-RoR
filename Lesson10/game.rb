require_relative 'user'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'

class Game
  attr_reader :user, :dealer, :deck

  def initialize(user_name:)
    @deck = Deck.new
    @user = User.new(user_name, @deck)
    @dealer = Dealer.new('Дилер', @deck)
  end

  def start_round
    puts "#{user.name}, игра началась!\nСтартовый баланс игроков: 100$."

    deck.renew
    user.cards = []
    dealer.cards = []

    2.times do
      user.take_card
      dealer.take_card
    end

    user.player_make_bet
    dealer.player_make_bet

    show_info
  end

  def dealer_make_move
    return dealer.skip_round unless dealer.should_take_card?

    dealer.take_card
    puts 'Дилер берет карту! '
  end

  def take_card
    user.take_card
  end

  def stop_game?
    dealer.cards.size == 3 && user.cards.size == 3
  end

  def show_info
    puts <<~TEXT
      Текущий баланс #{user.show_balance}$. Ваша ставка: #{Bank::BET}$.
      Карты в руке: #{user.show_hand}. Номинал: #{user.check_cards_value}.
      Карты Дилера #{dealer.hide_cards}.
    TEXT
  end

  def skip_round
    puts 'Вы пропускаете ход! '
  end

  def open_cards
    puts <<~TEXT
      Карты в руке: #{user.show_hand}. Номинал: #{user.check_cards_value}.
      Карты Дилера #{dealer.show_hand}. Номинал: #{dealer.check_cards_value}.
    TEXT
  end

  def check_balances
    if user.show_balance.zero?
      'Ваш баланс 0. Приходите отыграться!'
    elsif dealer.show_balance.zero?
      'Баланс дилера 0. Вы победили!'
    end
  end

  def define_winner
    user_count = user.check_cards_value
    dealer_count = dealer.check_cards_value

    if user_count == dealer_count
      user.player_return_bet
      dealer.player_return_bet
      "\nНичья!"
    elsif user_count > dealer_count && user_count <= 21
      user.player_win_bet
      "\n#{user.name} выиграл!"
    else
      dealer.player_win_bet
      "\n#{dealer.name} выиграл!"
    end
  end

  def total_balance
    puts <<~TEXT
      #{user.name}: Баланс #{user.show_balance}$.
      #{dealer.name}: Баланс #{dealer.show_balance}$.
    TEXT
  end
end
