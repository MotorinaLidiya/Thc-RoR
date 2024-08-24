require_relative 'train.rb'

class CargoTrain < Train
  TYPE = :cargo

  def initialize(number, current_speed = 0)
    super(number, TYPE, current_speed)
  end
end
