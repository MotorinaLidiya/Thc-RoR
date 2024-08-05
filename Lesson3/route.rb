# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся
# при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
class Route
  attr_reader :first_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]
  end

  def add_transit_station(transit_station)
    return @stations.insert(-2, transit_station) unless @stations.include?(transit_station)

    puts 'Эта станция уже есть в маршруте.'
  end

  def delete_transit_station(transit)
    return @stations.delete(transit) if @stations.include?(transit) && @stations.first != transit && @stations.last != transit

    puts 'Станция не доступна к удалению из маршрута.'
  end

  def show_route
    @stations.each_with_index { |stations, index| puts "#{index + 1}. #{stations}" }
  end
end
