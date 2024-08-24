require_relative 'game'

class BlackJack
  def initialize
    puts 'Привет! Назовись!'
    name = gets.chomp
    name = 'Игрок' if name == ''

    @game = Game.new(user_name: name)
  end

  def play_game
    loop do
      @game.start_round
      play_round
      sleep 1
      round_results

      balance_left = @game.check_balances
      return puts balance_left if balance_left

      puts "#{@game.user.name}, хотите сыграть еще раз? (0 - выход, 1 - следующая игра) "
      user_input = gets.to_i
      break if user_input.zero?
    end
  end

  private

  def round_results
    @game.open_cards
    puts @game.define_winner
    puts @game.total_balance
  end

  def play_round
    attempts = 0
    @previous_input = nil

    loop do
      show_actions
      user_input = gets.to_i

      if user_input == @previous_input || ![1, 2, 3].include?(user_input)
        puts 'Выберите корретное действие. Нельзя выбрать действие повторно. '
        next
      end
      break if user_input == 3

      @previous_input = user_input
      action(user_input)
      attempts += 1
      break if attempts >= 2 || @game.stop_game?

      @game.dealer_make_move
      break if @game.stop_game?

      @game.show_info
    end
  end

  MENU = [
    { id: 1, title: 'Пропустить ход', action: :skip_round },
    { id: 2, title: 'Добавить карту', action: :take_card },
    { id: 3, title: 'Открыть карты', action: :open_cards }
  ].freeze

  def show_actions
    MENU.each { puts "#{_1[:id]}. #{_1[:title]}" }
  end

  def action(choice)
    action = MENU.find { |item| item[:id] == choice }&.dig(:action)

    action ? @game.send(action) : puts('Введите корректный номер действия. ')
  end
end

game = BlackJack.new
game.play_game
