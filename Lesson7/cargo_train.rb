require_relative 'train'

class CargoTrain < Train
  def initialize(number, current_speed = 0)
    super(number, :cargo, current_speed)
  end
end
