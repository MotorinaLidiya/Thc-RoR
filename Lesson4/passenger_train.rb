require_relative 'train.rb'

class PassengerTrain < Train
  TYPE = :passenger

  def initialize(number, current_speed = 0)
    super(number, TYPE, current_speed)
  end
end
