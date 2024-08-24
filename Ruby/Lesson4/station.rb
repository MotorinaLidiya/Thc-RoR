class Station
  attr_reader :trains
  attr_accessor :name

  def initialize(name)
    @name = name
    @trains = []
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
