# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#  Создавать станции
#  Создавать поезда
#  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#  Назначать маршрут поезду
#  Добавлять/ отцеплять вагоны
#  Перемещать поезд по маршруту вперед и назад
#  Просматривать список станций и список поездов на станции

require_relative 'cargo_train.rb'
require_relative 'cargo_wagon.rb'
require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'station.rb'
require_relative 'wagon.rb'
require_relative 'seed.rb'

class RailRoad
  @stations = @trains = @wagons = @routes = []

  def seed
    @stations, @trains, @wagons, @routes = Seed.create
  end

  def menu_manager
    loop do
      # puts command_list
      user_input = gets.to_i
      break if user_input.zero?

      user_choice(user_input)
      # sleep(1.5)
    end
  end

  private

  def command_list
    <<~MENU
      Введите, чтобы выполнить действие (или нажмите 0 для выхода):
      1. Создать станцию
      2. Создать поезд
      3. Создать маршрут
      4. Управлять станциями в маршруте (добавлять, удалять)
      5. Назначить маршрут поезду
      6. Добавить вагон поезда
      7. Отцепить вагон поезда
      8. Перемещать поезд по маршруту вперед или назад
      9. Просмотреть список станций
      10. Просмотреть список поездов на станции
      11. Добавить вагон
    MENU
  end

  def user_choice(user_input)
    case user_input
    when 1 then add_station
    when 2 then add_train
    when 3 then add_route
    when 4 then route_manager
    when 5 then assign_route
    when 6 then attach_wagon
    when 7 then detach_wagon
    when 8 then move_train
    when 9 then stations_list
    when 10 then add_wagon
    end
  end

  def add_station
    puts 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
    puts "Добавлена станция #{name}."
  end

  def add_train
    puts 'Введите название поезда: '
    train = gets.chomp
    puts 'Выберите тип поезда:
      1. пассажирский
      2. грузовой '
    type = gets.to_i
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
    puts 'Введите первую станцию маршрута: '
    first_station_name = gets.chomp
    puts 'Введите последнюю станцию маршрута: '
    last_station_name = gets.chomp

    first_station = @stations.find { _1.name == first_station_name }
    last_station = @stations.find { _1.name == last_station_name }

    if first_station && last_station
      route = Route.new(first_station, last_station)
      @routes << route
      puts 'Маршрут создан.'
    else
      puts 'Нет информации о введенных станциях.'
    end
  end

  def route_manager
    puts 'Какой маршрут Вы хотите изменить? Введите первую и последнюю станцию. '
    first_station_name = gets.chomp
    last_station_name = gets.chomp
    route = @routes.find { _1.first_station.name == first_station_name && _1.last_station.name == last_station_name}
    if route
      puts 'Маршрут готов к редактированию. Какое действие Вы хотите совершить в маршруте?
      1. добавить станцию
      2. удалить станцию'
      user_input = gets.to_i
      case user_input
      when 1
        puts 'Какую станцию Вы хотите добавить?'
        transit_station_name = gets.chomp
        transit_station = @stations.find { _1.name == transit_station_name }
        if transit_station
          route.add_transit_station(transit_station)
          puts 'Станция добавлена'
        end
      when 2
        puts 'Какую станцию Вы хотите удалить?'
        transit_station_name = gets.chomp
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
    puts 'Укажите название поезда: '
    train_number = gets.chomp
    train = @trains.find { _1.number == train_number }
    if train
      puts 'Укажите маршрут. Введите первую и последнюю станцию.'
      first_station = gets.chomp
      last_station = gets.chomp
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
    puts 'Укажите тип вагона для добавления:
      1. пассажирский
      2. грузовой '
    type = gets.to_i
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
    puts 'Укажите название поезда: '
    train_number = gets.chomp
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
    puts 'Укажите название поезда: '
    train_number = gets.chomp
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
    puts 'Укажите название поезда: '
    train_number = gets.chomp
    train = @trains.find { _1.number == train_number }

    if train
      puts 'Укажите куда переместить поезд по маршруту:
      1. вперед
      2. назад'
      train_moves = gets.to_i
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
end

menu = RailRoad.new
menu.seed
menu.menu_manager
