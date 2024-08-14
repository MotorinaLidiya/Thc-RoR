require_relative 'wagon'

class CargoWagon < Wagon
  TYPE = :cargo

  def initialize(all_volume)
    super(TYPE)
    @free_volume = all_volume
    @occupied_volume = 0
  end

  def occupy_volume(volume)
    @free_volume -= volume
    @occupied_volume += volume
  end

  def to_s
    super
    "Свободный объем в вагоне: #{@free_volume}. Занятый объем в вагоне: #{@occupied_volume}. "
  end
end
