# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#  Создавать станции
#  Создавать поезда
#  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#  Назначать маршрут поезду
#  Добавлять/ отцеплять вагоны
#  Перемещать поезд по маршруту вперед и назад
#  Просматривать список станций и список поездов на станции

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
    @stations.each { |element| puts element }
    first_station_name = string_choice('Введите первую станцию маршрута: ')
    last_station_name = string_choice('Введите последнюю станцию маршрута: ')

    first_station = @stations.find { _1.name == first_station_name }
    last_station = @stations.find { _1.name == last_station_name }
    return puts 'Нет информации о введенных станциях. ' unless first_station && last_station

    return puts 'Введите разные станции. ' if first_station == last_station

    route = Route.new(first_station, last_station)
    @routes << route
    puts 'Маршрут создан. '
  end

  def route_manager
    @routes.each { |element| puts element }
    first_station_name = string_choice('Какой маршрут Вы хотите изменить? Введите первую станцию маршрута: ')
    last_station_name = string_choice('Введите последнюю станцию маршрута: ')
    route = @routes.find { _1.first_station.name == first_station_name && _1.last_station.name == last_station_name}
    return puts 'Маршрут не найден. ' unless route

    user_input = number_choice('Маршрут готов к редактированию. Какое действие Вы хотите совершить в маршруте?
    1. добавить станцию
    2. удалить станцию ')
    @stations.each { |element| puts element }

    case user_input
    when 1
      transit_station_name = string_choice('Какую станцию Вы хотите добавить? ')
      transit_station = @stations.find { _1.name == transit_station_name }
      if transit_station
        route.add_transit_station(transit_station)
        puts 'Станция добавлена. '
      end
    when 2
      transit_station_name = string_choice('Какую станцию Вы хотите удалить? ')
      transit_station = @stations.find { _1.name == transit_station_name }
      if transit_station
        route.delete_transit_station(transit_station)
        puts 'Станция удалена. '
      end
    else
      puts 'Введите 1 или 2. '
    end
  end

  def assign_route
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }
    return puts 'Нет данных о поезде. ' unless train

    @routes.each { |element| puts element }
    first_station = string_choice('Укажите маршрут. Введите первую станцию маршрута: ')
    last_station = string_choice('Введите последнюю станцию маршрута: ')
    route = @routes.find { _1.first_station.name == first_station && _1.last_station.name == last_station}
    return puts 'Маршрут не найден. ' unless route

    train.takes_route(route)
    puts "Маршрут назначен для #{train} "
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
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }
    return puts 'Нет данных о поезде. ' unless train

    train_type = train.type
    wagon = @wagons.find { _1.type == train_type && _1.is_attached == false }
    return puts 'Нет доступного вагона к добавлению. ' unless wagon

    train.attach_wagon(wagon)
    wagon.is_attached = true
    puts 'Вагон успешно добавлен к поезду. '
  end

  def detach_wagon
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }
    return puts 'Нет данных о поезде. ' unless train

    train_type = train.type
    wagon = train.wagons.find { _1.type == train_type && _1.is_attached == true}
    return puts 'Нет вагонов в поезде. ' unless wagon

    train.detach_wagon(wagon)
    wagon.is_attached = false
    puts 'Вагон успешно отцеплен. '
  end

  def move_train
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }
    return puts 'Нет данных о поезде. ' unless train

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
    @stations.each { |element| puts element }
    station_name = string_choice('Введите станцию, на которой хотите посмотреть список поездов: ')
    station = @stations.find { _1.name == station_name }

    return puts 'Нет данных о станции. ' unless station
    return puts 'На станции нет поездов. ' if station.trains.empty?

    station.each_train_on_station do |index, train|
      puts "#{index+1}. #{train}"
    end
  end

  def wagons_in_train
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }

    return puts 'Нет данных о поезде. ' unless train
    return puts 'У поезда нет вагонов. ' if train.wagons.empty?

    train.each_wagon_in_train do |index, wagon|
      puts "Вагон №#{index+1}. "
      puts wagon
    end
  end

  def take_space_in_wagon
    @trains.each { |element| puts element }
    train_number = string_choice('Укажите номер поезда, где хотите занять место/объем: ')
    train = @trains.find { _1.number == train_number }

    return puts 'Нет данных о поезде. ' unless train
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
end

menu = RailRoad.new
menu.seed
menu.start
