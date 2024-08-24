require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'station'
require_relative 'wagon'
require_relative 'seed'

class RailRoad
  @stations = @trains = @wagons = @routes = []

  def seed
    @stations, @trains, @wagons, @routes = Seed.create
  end

  def start
    loop do
      puts
      show_menu
      choice = number_choice('Выберите номер действия')
      action(choice)
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

  def number_choice(output)
    puts output.to_s
    gets.chomp.to_i
  end

  def string_choice(output)
    puts output.to_s
    gets.chomp
  end

  def action(choice)
    action = MENU.find { |item| item[:id] == choice }&.dig(:action)
    if action
      exit_program if action == :exit
      send(action)
    else
      puts 'Введите корректный номер действия '
    end
  end

  def add_station
    loop do
      @name = string_choice('Введите название станции :')
      @stations << Station.new(@name)
      puts "Добавлена станция #{@name}. "
      break
    rescue RuntimeError => e
      puts e
      sleep 1
      retry
    end
  end

  def add_train
    loop do
      type = number_choice('Выберите тип поезда:
        1. пассажирский
        2. грузовой ')
      raise 'Введите 1 или 2 для выбора типа поезда. ' unless [1, 2].include?(type)

      train = string_choice('Введите номер поезда: ')
      puts case type
           when 1
             @trains << PassengerTrain.new(train, type)
             "Добавлен пассажирский поезд #{train}."
           when 2
             @trains << CargoTrain.new(train, type)
             "Добавлен грузовой поезд #{train}."
           end
      break
    rescue RuntimeError => e
      puts e
      sleep 1
      retry
    end
  end

  def add_route
    puts 'Для добавления маршрута введите первую станцию маршрута: '
    first_station = select_item(@stations)
    puts 'Введите вторую станцию маршрута: '
    last_station = select_item(@stations)

    return puts 'Нельзя создать маршрут из одинаковых станций ' if first_station == last_station

    route = Route.new(first_station, last_station)
    @routes << route
    puts 'Маршрут создан. '
  end

  def route_manager
    route = select_route
    loop do
      user_input = number_choice('Маршрут готов к редактированию. Какое действие Вы хотите совершить в маршруте?
      1. добавить станцию
      2. удалить станцию ')

      case user_input
      when 1
        puts 'Какую станцию Вы хотите добавить? '
        transit_station = select_item(@stations)
        if transit_station
          route.add_transit_station(transit_station)
          puts 'Станция добавлена. '
        end
      when 2
        puts 'Какую станцию Вы хотите удалить? '
        transit_station = select_item(@stations)
        if transit_station
          route.delete_transit_station(transit_station)
          puts 'Станция удалена. '
        end
      else
        raise 'Введите 1 или 2. '
      end
      break
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def assign_route
    train = select_item(@trains)
    route = select_route

    train.takes_route(route)
    puts "Маршрут назначен для #{train}"
  rescue StandardError => e
    puts e.message
  end

  def add_wagon
    type = number_choice('Укажите тип вагона для добавления:
      1. пассажирский
      2. грузовой ')
    puts case type
         when 1
           number_of_seats = number_choice('Укажите количество мест в вагоне: ')
           @wagons << PassengerWagon.new(number_of_seats)
           'Добавлен пассажирский вагон. '
         when 2
           all_volume = number_choice('Укажите объем вагона: ')
           @wagons << CargoWagon.new(all_volume)
           'Добавлен грузовой вагон. '
         else
           'Введите 1 или 2. '
         end
  end

  def attach_wagon
    train = select_item(@trains)
    wagon = @wagons.find { _1.type == train.type && _1.is_attached == false }

    raise 'Нет доступного вагона к добавлению. ' unless wagon

    train.attach_wagon(wagon)
    wagon.is_attached = true
    puts 'Вагон успешно добавлен к поезду.'
  rescue StandardError => e
    puts e.message
  end

  def detach_wagon
    train = select_item(@trains)
    train.detach_wagon
    puts 'Вагон успешно отцеплен. '
  rescue StandardError => e
    puts e.message
  end

  def move_train
    train = select_item(@trains)

    train_moves = number_choice('Укажите куда переместить поезд по маршруту:
    1. вперед
    2. назад ')
    puts case train_moves
         when 1
           train.move_next_station
         when 2
           train.move_previous_station
         else
           'Введите 1 или 2. '
         end
  end

  def stations_list
    @stations.each.with_index(1) { |station, index| puts "#{index}. #{station}" }
  end

  def trains_on_station
    station = select_item(@stations)

    return puts 'На станции нет поездов. ' if station.trains.empty?

    station.each_train_on_station do |index, train|
      puts "#{index+1}. #{train}"
    end
  end

  def wagons_in_train
    train = select_item(@trains)
    return puts 'У поезда нет вагонов. ' if train.wagons.empty?

    train.each_wagon_in_train do |index, wagon|
      puts "Вагон №#{index+1}. "
      puts wagon
    end
  end

  def take_space_in_wagon
    train = select_item(@trains)
    return puts 'У поезда нет вагонов. ' if train.wagons.empty?

    wagons = []

    train.each_wagon_in_train do |index, wagon|
      puts "Вагон №#{index+1}. "
      puts wagon
      wagons << wagon
    end

    wagon_number = number_choice('В каком вагоне поезда Вы хотите занять место/объем? Введите номер этого вагона: ')
    return puts 'Введен неверный номер вагона.' unless wagon_number.between?(1, wagons.size)

    wagon = wagons[wagon_number - 1]
    puts "Вы выбрали вагон №#{wagon_number}. "

    volume = number_choice('Какой объем занять в грузовом вагоне? ') if wagon.type == :cargo
    wagon.type == :cargo ? wagon.occupy_volume(volume) : wagon.occupy_seat
    puts 'Данные успешно добавлены. '
  end

  def exit_program
    puts 'Выход из программы.'
  end

  def select_item(collection)
    collection.each_with_index { |item, index| puts "#{index + 1}. #{item} "}
    begin
      item_name = string_choice('Введите название нужного объекта: ')
      item = collection.find do |i|
        field_name = i.respond_to?(:name) ? i.name : i.number
        field_name == item_name
      end

      raise 'Нет информации о введенных данных. ' unless item
    rescue StandardError => e
      puts e.message
      retry
    end

    item
  end

  def select_route
    @routes.each_with_index { |item, index| puts "#{index + 1}. #{item} "}
    begin
      route_index = number_choice('Укажите номер маршрута: ')

      raise 'Введите корректный номер маршрута.  ' unless route_index.between?(1, @routes.size)
    rescue StandardError => e
      puts e.message
      retry
    end

    route = @routes[route_index - 1]
    puts "Вы выбрали маршрут: #{route}"
    puts 'Станции в маршруте: '
    route.stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    route
  end
end

menu = RailRoad.new
# require 'debug'
menu.seed
menu.start
