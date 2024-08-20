require_relative 'train'

class PassengerTrain < Train
  def initialize(number, current_speed = 0)
    super(number, :passenger, current_speed)
  end
end
