require_relative 'player'

class Dealer < Player
  def skip_round
    puts 'Дилер пропускает ход! '
    sleep 1
  end

  def should_take_card?
    check_cards_value < 17
  end

  def hide_cards
    '* ' * cards.size
  end
end
