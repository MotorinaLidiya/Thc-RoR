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
      @game.open_cards

      puts @game.define_winner
      puts @game.total_balance

      result = @game.check_balances
      return puts result if result

      puts "#{@game.user.name}, хотите сыграть еще раз? (0 - выход, 1 - следующая игра) "
      user_input = gets.to_i
      break if user_input.zero?
    end
  end

  private

  def play_round
    loop do
      show_actions
      user_choice = gets.to_i
      break if user_choice == 3

      action(user_choice)
      break if @game.stop_game?

      sleep 1
      @game.dealer_make_move
      break if @game.stop_game?
      @game.show_info
    end
  end

  MENU = [
    {id: 1, title: 'Пропустить ход', action: :skip_round},
    {id: 2, title: 'Добавить карту', action: :take_card},
    {id: 3, title: 'Открыть карты', action: :open_cards},
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
