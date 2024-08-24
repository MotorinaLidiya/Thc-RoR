class Bank
  attr_reader :balance

  BET = 10

  def initialize
    @balance = 100
  end

  def make_bet
    @balance -= BET
  end

  def return_bet
    @balance += BET
  end

  def win_bet
    @balance += BET * 2
  end
end
