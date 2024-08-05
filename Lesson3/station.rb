# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
class Station
  attr_reader :trains
  attr_accessor :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def train_enters(train)
    return @trains << train unless @trains.include?(train)

    puts "Этот поезд уже находится на станции #{@name}."
  end

  def train_left(train)
    return @trains.delete(train) if @trains.include?(train)

    puts "Этого поезда нет на станции #{@name}."
  end

  def trains_output
    passenger_trains, cargo_trains = @trains.partition(&:passenger_type?)

    puts "Список поездов на станции #{@name}: пассажирские - #{passenger_trains.map(&:to_s)}, грузовые - #{cargo_trains.map(&:to_s)}"
  end

  def to_s
    "Название станции #{@name}, поезда на станции #{@trains.map(&:to_s)}."
  end
end
