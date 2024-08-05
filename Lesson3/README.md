### Lesson 3

* Запуск (ruby version 3.1.2):

`irb -r ./station.rb -r ./route.rb -r ./train.rb`

* Пример работы
```
station1 = Station.new('Сокол')
station2 = Station.new('Павелецкая')
station3 = Station.new('Тверская')

train1 = Train.new(1, 'пассажирский', 10)
train2 = Train.new(2, 'грузовой', 2)
station2.train_enters(train2)
puts train1
train1.current_speed = 59
train1.attach_wagon # (не сможет добавить вагон, тк скорость != 0)
train1.stop
train1.detach_wagon # (после остановки уберет вагон)

puts station1  # (все поезда на станции)
station1.trains_output # (делит поезда по типам)

route1 = Route.new(station1, station2)
route1.add_transit_station(station3) # (добавит станцию между первой и последней)
route1.show_route
route1.delete_transit_station(station3) # (удалит станцию, при условии, что она есть в маршруте и она не первая/последняя)

train1.takes_route(route1) # (Поставит поезд на Сокол)
train1.current_station
train1.previous_station
train1.next_station
train1.move_next_station # (Переместит на Тверскую)
train1.move_previous_station # (Обратно на Сокол)

```