require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains
  attr_accessor :name

  NAME_FORMAT = /^[А-Я][а-я]+(-[А-Я][а-я]+)?$/i

  @stations = []

  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []

    validate!
    self.class.stations << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
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

  def validate!
    errors = []
    errors << 'Минимальное количество символов: 4' if name.size < 4
    errors << 'Максимальное количество символов: 30' if name.size > 30
    errors << 'Используйте только русские буквы' if name !~ NAME_FORMAT
    raise errors.join('. ') unless errors.empty?
  end

  def trains_by_type(type)
    @trains.select { |train| train.class::TYPE == type }
  end
end
