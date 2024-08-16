require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(number_of_seats)
    super(:passenger, number_of_seats)
  end

  def occupy_seat
    raise 'Недостаточно места в вагоне. ' if free_place.zero?

    @used_place += 1
  end

  def to_s
    super
    "Свободных мест в вагоне: #{free_place}. Занятых мест в вагоне: #{@used_place}. "
  end
end
