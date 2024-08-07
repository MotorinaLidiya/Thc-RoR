require_relative 'wagon.rb'

class PassengerWagon < Wagon
  TYPE = :passenger

  def initialize
    super(TYPE)
  end
end
