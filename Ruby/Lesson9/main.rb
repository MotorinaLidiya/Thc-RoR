require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'station'
require_relative 'wagon'
require_relative 'seed'
require_relative 'output'

class RailRoad
  @stations = @trains = @wagons = @routes = []

  def seed
    @stations, @trains, @wagons, @routes = Seed.create
  end

  def start
    loop do
      puts
      show_menu
      choice = Output.number_choice('Выберите номер действия')
      Output.with_rescue { puts action(choice) }
    end
  end

  private

  MENU = [
    {id: 1, title: 'Создать станцию', action: :add_station},
    {id: 2, title: 'Создать поезд', action: :add_train},
    {id: 3, title: 'Создать маршрут', action: :add_route},
    {id: 4, title: 'Управлять станциями в маршруте (добавлять, удалять)', action: :route_manager},
    {id: 5, title: 'Назначить маршрут поезду', action: :assign_route},
    {id: 6, title: 'Создать вагон', action: :add_wagon},
    {id: 7, title: 'Добавить вагон поезду', action: :attach_wagon},
    {id: 8, title: 'Отцепить вагон от поезда', action: :detach_wagon},
    {id: 9, title: 'Перемещать поезд по маршруту вперед или назад', action: :move_train},
    {id: 10, title: 'Просмотреть список всех станций', action: :stations_list},
    {id: 11, title: 'Просмотреть список поездов на станции', action: :trains_on_station},
    {id: 12, title: 'Просмотреть список вагонов в поезде', action: :wagons_in_train},
    {id: 13, title: 'Занять место в пассажирском вагоне/объем в грузовом вагоне', action: :take_space_in_wagon},
    {id: 0, title: 'Выход из программы', action: :exit}
  ].freeze

  def show_menu
    MENU.each { puts "#{_1[:id]}. #{_1[:title]}" }
  end

  def action(choice)
    action = MENU.find { |item| item[:id] == choice }&.dig(:action)
    if action
      exit_program if action == :exit
      send(action)
    else
      'Введите корректный номер действия. '
    end
  end

  def add_station
    @name = Output.string_choice('Введите название станции :')
    @stations << Station.new(@name)
    "Добавлена станция #{@name}. "
  end

  def add_train
    type = Output.number_choice('Выберите тип поезда:
      1. пассажирский
      2. грузовой ')
    Output.error 'Введите 1 или 2 для выбора типа поезда. ' unless [1, 2].include?(type)

    train = Output.string_choice('Введите номер поезда: ')
    case type
    when 1
      @trains << PassengerTrain.new(train, type)
      "Добавлен пассажирский поезд #{train}."
    when 2
      @trains << CargoTrain.new(train, type)
      "Добавлен грузовой поезд #{train}."
    end
  end

  def add_route
    puts 'Для добавления маршрута введите первую станцию маршрута: '
    first_station = Output.select_item(@stations) || return
    puts 'Введите вторую станцию маршрута: '
    last_station = Output.select_item(@stations) || return
    route = Route.new(first_station, last_station)
    @routes << route
    'Маршрут создан.'
  end

  def route_manager
    route = select_route
    user_input = Output.number_choice('Маршрут готов к редактированию. Какое действие Вы хотите совершить в маршруте?
    1. добавить станцию
    2. удалить станцию ')

    case user_input
    when 1
      puts 'Какую станцию Вы хотите добавить? '
      transit_station = Output.select_item(@stations) || return
      if transit_station
        route.add_transit_station(transit_station)
        'Станция добавлена. '
      end
    when 2
      puts 'Какую станцию Вы хотите удалить? '
      transit_station = Output.select_item(@stations) || return
      if transit_station
        route.delete_transit_station(transit_station)
        'Станция удалена. '
      end
    else
      Output.error 'Введите 1 или 2. '
    end
  end

  def assign_route
    train = Output.select_item(@trains) || return
    route = select_route

    train.takes_route(route)
    "Маршрут назначен для #{train}"
  end

  def add_wagon
    type = Output.number_choice('Укажите тип вагона для добавления:
      1. пассажирский
      2. грузовой ')

    case type
    when 1
      number_of_seats = Output.number_choice('Укажите количество мест в вагоне: ')
      @wagons << PassengerWagon.new(number_of_seats)
      'Добавлен пассажирский вагон. '
    when 2
      all_volume = Output.number_choice('Укажите объем вагона: ')
      @wagons << CargoWagon.new(all_volume)
      'Добавлен грузовой вагон. '
    else
      Output.error 'Введите 1 или 2. '
    end
  end

  def attach_wagon
    train = Output.select_item(@trains) || return
    wagon = @wagons.find { _1.type == train.type && _1.is_attached == false }
    Output.error 'Нет доступного вагона к добавлению. ' unless wagon

    train.attach_wagon(wagon)
    wagon.is_attached = true
    'Вагон успешно добавлен к поезду.'
  end

  def detach_wagon
    train = Output.select_item(@trains) || return
    train.detach_wagon
    'Вагон успешно отцеплен. '
  end

  def move_train
    train = Output.select_item(@trains) || return

    train_moves = Output.number_choice('Укажите куда переместить поезд по маршруту:
    1. вперед
    2. назад ')

    case train_moves
    when 1 then train.move_next_station
    when 2 then train.move_previous_station
    else Output.error 'Введите 1 или 2. '
    end
  end

  def stations_list
    @stations.map.with_index(1) { |station, index| "#{index}. #{station}" }
  end

  def trains_on_station
    station = Output.select_item(@stations) || return

    return 'На станции нет поездов. ' if station.trains.empty?

    station.each_train_on_station { |index, train| "#{index + 1}. #{train}" }
  end

  def wagons_in_train
    train = Output.select_item(@trains) || return
    return 'У поезда нет вагонов. ' if train.wagons.empty?

    train.map_wagon_in_train { |wagon, index| "Вагон №#{index}. #{wagon}" }
  end

  def take_space_in_wagon
    train = Output.select_item(@trains) || return
    return 'У поезда нет вагонов. ' if train.wagons.empty?

    wagons = train.map_wagon_in_train do |wagon, index|
      puts "Вагон №#{index}. #{wagon}"
      wagon
    end

    wagon_number = Output.number_choice('В каком вагоне поезда Вы хотите занять место/объем? Введите номер этого вагона: ')
    return 'Введен неверный номер вагона.' unless wagon_number.between?(1, wagons.size)

    wagon = wagons[wagon_number - 1]
    puts "Вы выбрали вагон №#{wagon_number}. "

    volume = Output.number_choice('Какой объем занять в грузовом вагоне? ') if wagon.type == :cargo
    wagon.type == :cargo ? wagon.occupy_volume(volume) : wagon.occupy_seat
    'Данные успешно добавлены. '
  end

  def exit_program
    puts 'Выход из программы.'
  end

  def select_route
    @routes.each_with_index { |item, index| puts "#{index + 1}. #{item} "}

    route_index = Output.number_choice('Укажите номер маршрута: ')
    Output.error 'Введите корректный номер маршрута.  ' unless route_index.between?(1, @routes.size)

    route = @routes[route_index - 1]
    puts "Вы выбрали маршрут: #{route}"
    puts 'Станции в маршруте: '
    route.stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    route
  end
end

menu = RailRoad.new
menu.seed
menu.start
