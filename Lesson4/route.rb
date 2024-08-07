class Route
  attr_reader :first_station, :last_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]
  end

  def add_transit_station(transit_station)
    return @stations.insert(-2, transit_station) unless @stations.include?(transit_station)

    'Эта станция уже есть в маршруте.'
  end

  def delete_transit_station(transit)
    return @stations.delete(transit) if @stations.include?(transit) && @stations.first != transit && @stations.last != transit

    'Станция не доступна к удалению из маршрута.'
  end

  def show_route
    @stations.each_with_index { |stations, index| puts "#{index + 1}. #{stations}" }
  end
end
