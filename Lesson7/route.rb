require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :first_station, :last_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]

    register_instance
  end

  def to_s
    "Маршрут: #{@first_station.name} - #{@last_station.name}"
  end

  def add_transit_station(transit_station)
    raise 'Эта станция уже есть в маршруте.' if @stations.include?(transit_station)

    @stations.insert(-2, transit_station)
  end

  def delete_transit_station(transit)
    unless @stations.include?(transit) && @stations.first != transit && @stations.last != transit
      raise 'Станция не доступна к удалению из маршрута.'
    end

    @stations.delete(transit)
  end

  def show_route
    @stations.each_with_index { |stations, index| puts "#{index + 1}. #{stations}" }
  end
end
