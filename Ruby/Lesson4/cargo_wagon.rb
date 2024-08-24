require_relative 'wagon.rb'

class CargoWagon < Wagon
  TYPE = :cargo

  def initialize
    super(TYPE)
  end
end
