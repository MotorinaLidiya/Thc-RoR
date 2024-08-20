require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(all_volume)
    super(:cargo, all_volume)
  end

  def occupy_volume(volume)
    raise 'Недостаточно места в вагоне. ' if free_place < volume

    @used_place += volume
  end

  def to_s
    super
    "Свободный объем в вагоне: #{free_place}. Занятый объем в вагоне: #{@used_place}. "
  end
end
