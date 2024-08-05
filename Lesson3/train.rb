# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются
# при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
# Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
class Train
  attr_accessor :current_speed
  attr_reader :wagons_count
  attr_writer :route

  def initialize(number, type, wagons_count, current_speed = 0)
    @number = number
    @type = type
    @wagons_count = wagons_count
    @current_speed = current_speed
    @route = nil
  end

  def passenger_type?
    @type == 'пассажирский'
  end

  def attach_wagon
    return @wagons_count += 1 if @current_speed.zero?

    puts 'Поезд движется, нельзя прицепить вагон.'
  end

  def detach_wagon
    if @current_speed != 0
      puts 'Поезд движется, нельзя отцепить вагон.'
    elsif @wagons_count > 1
      @wagons_count -= 1
    else
      puts 'Остался последний вагон поезда, нет вагонов для отцепления.'
    end
  end

  def stop
    @current_speed = 0
  end

  def to_s
    "Номер поезда #{@number}, количество вагонов #{@wagons_count}"
  end

  def takes_route(route)
    @route = route
    @route.first_station.train_enters(self)
    @current_station = 0
  end

  def move_next_station
    if @route && @current_station < @route.stations.size - 1
      @route.stations[@current_station].train_left(self)
      @current_station += 1
      @route.stations[@current_station].train_enters(self)
      puts "Поезд перемещен на станцию вперед: #{@route.stations[@current_station]}"
    else
      puts 'Нет следующей станции для перемещения.'
    end
  end

  def move_previous_station
    if @route && @current_station.positive?
      @route.stations[@current_station].train_left(self)
      @current_station -= 1
      @route.stations[@current_station].train_enters(self)
      puts "Поезд перемещен на станцию назад: #{@route.stations[@current_station]}"
    else
      puts 'Нет предыдущей станции для перемещения.'
    end
  end

  def current_station
    @route.stations[@current_station] if @route
  end

  def next_station
    if @route && @current_station < @route.stations.size - 1
      "Следующая станция: #{@route.stations[@current_station + 1]}"
    else
      'Нет следующей станции'
    end
  end

  def previous_station
    if @route && @current_station.positive?
      "Предыдущая станция: #{@route.stations[@current_station - 1]}"
    else
      'Нет предыдущей станции'
    end
  end
end
