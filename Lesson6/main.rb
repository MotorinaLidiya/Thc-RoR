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
require_relative 'lesson_error'

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
    rescue LessonError => e
      puts
      puts e
      sleep 2
    end
  end

  private

  MENU = [
    {id: 1, title: 'Создать станцию', action: :add_station},
    {id: 2, title: 'Создать поезд', action: :add_train},
    {id: 3, title: 'Создать маршрут', action: :add_route},
    {id: 4, title: 'Управлять станциями в маршруте (добавлять, удалять)', action: :route_manager},
    {id: 5, title: 'Назначить маршрут поезду', action: :assign_route},
    {id: 6, title: 'Добавить вагон поезда', action: :attach_wagon},
    {id: 7, title: 'Отцепить вагон поезда', action: :detach_wagon},
    {id: 8, title: 'Перемещать поезд по маршруту вперед или назад', action: :move_train},
    {id: 9, title: 'Просмотреть список станций и список поездов на станции', action: :stations_list},
    {id: 10, title: 'Создать вагон', action: :add_wagon},
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
      puts 'Введите корректный номер действия'
    end
  end

  def add_station
    name = string_choice('Введите название станции')
    @stations << Station.new(name)
    puts "Добавлена станция #{name}."
  end

  def add_train
    train = number_choice('Введите номер поезда: ')
    type = number_choice('Выберите тип поезда:
        1. пассажирский
        2. грузовой')
    puts case type
         when 1
           @trains << PassengerTrain.new(train, type)
           "Добавлен пассажирский поезд #{train}."
         when 2
           @trains << CargoTrain.new(train, type)
           "Добавлен грузовой поезд #{train}."
         else
           'Введите 1 или 2.'
         end
  end

  def add_route
    @stations.each { |element| puts element }
    first_station_name = string_choice('Введите первую станцию маршрута: ')
    last_station_name = string_choice('Введите последнюю станцию маршрута: ')

    first_station = @stations.find { _1.name == first_station_name }
    last_station = @stations.find { _1.name == last_station_name }
    if first_station == last_station
      puts 'Введите разные станции.'
      return
    end

    if first_station && last_station
      route = Route.new(first_station, last_station)
      @routes << route
      puts 'Маршрут создан.'
    else
      puts 'Нет информации о введенных станциях.'
    end
  end

  def route_manager
    @routes.each { |element| puts element }
    first_station_name = string_choice('Какой маршрут Вы хотите изменить? Введите первую станцию маршрута: ')
    last_station_name = string_choice('Введите последнюю станцию маршрута: ')
    route = @routes.find { _1.first_station.name == first_station_name && _1.last_station.name == last_station_name}

    if route
      user_input = number_choice('Маршрут готов к редактированию. Какое действие Вы хотите совершить в маршруте?
      1. добавить станцию
      2. удалить станцию')
      @stations.each { |element| puts element }
      case user_input
      when 1
        transit_station_name = string_choice('Какую станцию Вы хотите добавить?')
        transit_station = @stations.find { _1.name == transit_station_name }
        if transit_station
          route.add_transit_station(transit_station)
          puts 'Станция добавлена'
        end
      when 2
        transit_station_name = string_choice('Какую станцию Вы хотите удалить?')
        transit_station = @stations.find { _1.name == transit_station_name }
        if transit_station
          route.delete_transit_station(transit_station)
          puts 'Станция удалена'
        end
      else
        puts 'Введите 1 или 2. '
      end
    else
      puts 'Маршрут не найден. '
    end
  end

  def assign_route
    @trains.each { |element| puts element }
    train_number = number_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }
    if train
      @routes.each { |element| puts element }
      first_station = string_choice('Укажите маршрут. Введите первую станцию маршрута: ')
      last_station = string_choice('Введите последнюю станцию маршрута: ')
      route = @routes.find { _1.first_station.name == first_station && _1.last_station.name == last_station}
      if route
        train.takes_route(route)
        puts "Маршрут назначен поезду #{train}."
      else
        puts 'Маршрут не найден.'
      end
    else
      puts 'Нет данных о поезде.'
    end
  end

  def add_wagon
    type = number_choice('Укажите тип вагона для добавления:
      1. пассажирский
      2. грузовой ')
    puts case type
         when 1
           @wagons << PassengerWagon.new
           'Добавлен пассажирский вагон.'
         when 2
           @wagons << CargoWagon.new
           'Добавлен грузовой вагон.'
         else
           'Введите 1 или 2.'
         end
  end

  def attach_wagon
    @trains.each { |element| puts element }
    train_number = number_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }

    if train
      train_type = train.type
      wagon = @wagons.find { _1.type == train_type && _1.is_attached == false }

      if wagon
        train.attach_wagon(wagon)
        wagon.is_attached = true
        puts 'Вагон успешно добавлен к поезду.'
      else
        puts 'Нет доступного вагона к добавлению.'
      end
    else
      puts 'Нет данных о поезде.'
    end
  end

  def detach_wagon
    @trains.each { |element| puts element }
    train_number = number_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }

    if train
      train_type = train.type
      wagon = @wagons.find { _1.type == train_type && _1.is_attached == true}
      if wagon
        train.detach_wagon(wagon)
        wagon.is_attached = false
        puts 'Вагон успешно отцеплен.'
      else
        puts 'Нет вагонов в поезде.'
      end
    else
      puts 'Нет данных о поезде.'
    end
  end

  def move_train
    @trains.each { |element| puts element }
    train_number = number_choice('Укажите номер поезда: ')
    train = @trains.find { _1.number == train_number }

    if train
      train_moves = number_choice('Укажите куда переместить поезд по маршруту:
      1. вперед
      2. назад')
      puts case train_moves
           when 1
             train.move_next_station
           when 2
             train.move_previous_station
           else
             puts 'Введите 1 или 2.'
           end
    else
      puts 'Нет данных о поезде.'
    end
  end

  def stations_list
    @stations.each.with_index(1) { |station, index| puts "#{index}. #{station}" }
  end

  def exit_program
    puts 'Выход из программы.'
  end
end

menu = RailRoad.new
menu.seed
menu.start
