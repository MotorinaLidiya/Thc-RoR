require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains
  attr_accessor :name

  @stations = []
  # В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты),
  # созданные на данный момент
  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []

    self.class.stations << self
  end

  def train_enters(train)
    return @trains << train unless @trains.include?(train)

    "Этот поезд уже находится на станции #{@name}."
  end

  def train_left(train)
    return @trains.delete(train) if @trains.include?(train)

    "Этого поезда нет на станции #{@name}."
  end

  def trains_type_output
    "Список поездов на станции #{@name}: пассажирские - #{trains_by_type(:passenger).map(&:to_s)}, "\
    "грузовые - #{trains_by_type(:cargo).map(&:to_s)}"
  end

  def to_s
    "Название станции #{@name}, поезда на станции #{@trains.map(&:to_s)}."
  end

  private

  def trains_by_type(type)
    @trains.select { |train| train.class::TYPE == type }
  end
end
