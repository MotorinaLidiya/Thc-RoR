require_relative 'wagon'

class PassengerWagon < Wagon
  TYPE = :passenger

  def initialize(number_of_seats)
    super(TYPE)
    @free_seats = number_of_seats
    @occupied_seats = 0
  end

  def occupy_seat
    @free_seats -= 1
    @occupied_seats += 1
  end

  def to_s
    super
    "Свободных мест в вагоне: #{@free_seats}. Занятых мест в вагоне: #{@occupied_seats}. "
  end
end
