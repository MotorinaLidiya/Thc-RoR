require_relative 'company_name'
require_relative 'instance_counter'

class Train
  include CompanyName
  include InstanceCounter

  NUMBER_FORMAT = /^[0-9а-яА-Я]{3}-?[0-9а-яА-Я]{2}$/i

  attr_accessor :current_speed
  attr_reader :wagons, :number, :type
  attr_writer :route

  alias_method :name, :number

  class << self
    attr_accessor :all_trains

    @all_trains = []
    def find(train_number)
      @all_trains.find { |train| train.number == train_number}
    end
  end

  def initialize(number, type, current_speed = 0)
    @number = number
    @type = type
    @wagons = []
    @current_speed = current_speed
    @route = nil
    @current_station = nil

    validate!
    self.class.all_trains ||= []
    self.class.all_trains << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def attach_wagon(wagon)
    Output.error 'Поезд движется, нельзя прицепить вагон.' if @current_speed != 0

    if can_attach_wagon?(wagon)
      @wagons << wagon
      wagon.is_attached = true

      "Вагон прицеплен. Количество вагонов: #{@wagons.size}."
    else
      wagon.is_attached ? 'Вагон уже прицеплен к поезду.' : 'Невозможно прицепить вагон этого типа.'
    end
  end

  def detach_wagon
    Output.error 'Нет вагонов в поезде. ' if wagons.size.zero?
    Output.error 'Поезд движется, нельзя отцепить вагон.' if @current_speed != 0

    wagon = wagons.pop
    wagon.is_attached = false if wagon
    "Вагон отцеплен. Количество вагонов: #{wagons.size}."
  end

  def wagon_count
    wagons.size
  end

  def map_wagon_in_train
    wagons.map.with_index(1) do |wagon, index|
      yield(wagon, index) if block_given?
    end
  end

  def stop
    @current_speed = 0
  end

  def to_s
    "Поезд: #{number}, тип #{type}, количество вагонов: #{wagons.size}. "
  end

  def takes_route(route)
    Output.error "У поезда уже назначен #{@route}." if @route

    @route = route
    @current_station = 0
    @route.first_station.train_enters(self)
    "Поезд принимает маршрут: #{@route}"
  end

  def move_next_station
    if @route && @current_station < @route.stations.size - 1
      @route.stations[@current_station].train_left(self)
      @current_station += 1
      @route.stations[@current_station].train_enters(self)
      "Поезд перемещен на станцию вперед: #{@route.stations[@current_station]}"
    else
      'Нет следующей станции для перемещения.'
    end
  end

  def move_previous_station
    if @route && @current_station.positive?
      @route.stations[@current_station].train_left(self)
      @current_station -= 1
      @route.stations[@current_station].train_enters(self)
      "Поезд перемещен на станцию назад: #{@route.stations[@current_station]}"
    else
      'Нет предыдущей станции для перемещения.'
    end
  end

  def current_station
    @route.stations[@current_station].to_s if @route
  end

  def next_station
    if @route && @current_station < @route.stations.size - 1
      "Следующая станция: #{@route.stations[@current_station + 1].to_s}"
    else
      'Нет следующей станции'
    end
  end

  def previous_station
    if @route && @current_station.positive?
      "Предыдущая станция: #{@route.stations[@current_station - 1.to_s]}"
    else
      'Нет предыдущей станции'
    end
  end

  private

  def validate!
    Output.error 'Формат номера некорректный (пример формата: 123-45, абв-12, АВГ12)' if number !~ NUMBER_FORMAT
  end

  def can_attach_wagon?(wagon)
    wagon.type == type && wagon.is_attached == false
  end
end
