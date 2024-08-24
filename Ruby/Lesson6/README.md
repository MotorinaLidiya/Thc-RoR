### Lesson 4

* Запуск (ruby version 3.1.2):

`irb -r ./main.rb
ruby ./main.rb `

* Пример работы

```
menu = RailRoad.new
menu.seed
menu

station1 = Station.new('Сокол')
station2 = Station.new('Павелецкая')
station3 = Station.new('Тверская')
station4 = Station.new('Белорусская')
station5 = Station.new('Новослободская')

train1c = CargoTrain.new(1, 10) # 10 это скорость, не обязательна к вводу
train2p = PassengerTrain.new(2)
train3p = PassengerTrain.new(3)

wagon101c = CargoWagon.new
wagon102c = CargoWagon.new
wagon103c = CargoWagon.new
wagon104p = PassengerWagon.new
wagon105p = PassengerWagon.new

train1c.current_speed = 59
train1c.attach_wagon # (не сможет добавить вагон, тк скорость != 0)
train1c.stop
train1c.attach_wagon(wagon101c) # Кол-во вагонов: 1
train1c.attach_wagon(wagon104p) # Не прикрепит вагон другого типа
train2p.attach_wagon(wagon104p) # Кол-во вагонов: 1
train3p.attach_wagon(wagon104p) # Не прикрепит вагон, уже прицеплен к другому поезду
train1c.attach_wagon(wagon102c) # Количество вагонов: 2
train3p.attach_wagon(wagon105p) # Кол-во вагонов: 1
puts train1c
train1c.detach_wagon(wagon102c) # Вагон отцеплен. Количество вагонов: 1.
train1c.detach_wagon(wagon103c) # Не отцепит, тк вагон не прицеплен к поезду
train2p.detach_wagon(wagon105p) # Не отцепит, тк вагон уже прицеплен к другому поезду

route1 = Route.new(station1, station2)
route2 = Route.new(station2, station5)
route1.add_transit_station(station3)
route1.add_transit_station(station4)
route2.add_transit_station(station4)
route1.show_route
route2.show_route
route1.delete_transit_station(station3) # (удалит станцию, при условии, что она есть в маршруте и она не первая/последняя)
route1.delete_transit_station(station1) # Станция не доступна к удалению из маршрута (тк первая)
route1.delete_transit_station(station5) # Станция не доступна к удалению из маршрута (нет в маршруте)

train1c.takes_route(route1) # Поезд 1 встанет на маршрут 1
train2p.takes_route(route2)
train3p.takes_route(route2)

puts station1  # (все поезда на станции)
station1.trains_type_output # (делит поезда по типам)

train1c.current_station
train1c.previous_station # Нет предыдущей станции
train1c.next_station # Следующая станция: Название станции Тверская
train1c.move_next_station # (Переместит на Тверскую)
train1c.move_previous_station # (Обратно на Сокол)

```
