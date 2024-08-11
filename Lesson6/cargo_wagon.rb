require_relative 'wagon'

class CargoWagon < Wagon
  TYPE = :cargo

  def initialize
    super(TYPE)
  end
end
