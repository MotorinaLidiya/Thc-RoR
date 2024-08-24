class Seed
  class << self
    def create
      @station1 = Station.new('Сокол')
      @station2 = Station.new('Павелецкая')
      @station3 = Station.new('Тверская')
      @station4 = Station.new('Белорусская')
      @station5 = Station.new('Новослободская')

      @train1c = CargoTrain.new('456-78')
      @train2p = PassengerTrain.new('ПОЕ-зд')
      @train3p = PassengerTrain.new('поезд')

      @wagon101c = CargoWagon.new(130)
      @wagon102c = CargoWagon.new(150)
      @wagon103c = CargoWagon.new(130)
      @wagon104p = PassengerWagon.new(55)
      @wagon105p = PassengerWagon.new(50)

      @route1 = Route.new(@station1, @station2)
      @route2 = Route.new(@station2, @station5)

      @train1c.attach_wagon(@wagon101c)
      @train1c.attach_wagon(@wagon102c)
      @train2p.attach_wagon(@wagon104p)
      @train3p.attach_wagon(@wagon105p)

      @route1.add_transit_station(@station3)
      @route1.add_transit_station(@station4)
      @route2.add_transit_station(@station4)

      @train1c.takes_route(@route1)
      @train2p.takes_route(@route2)
      @train3p.takes_route(@route2)

      [stations, trains, wagons, routes]
    end

    private

    def stations
      [@station1, @station2, @station3,@station4, @station5]
    end

    def trains
      [@train1c, @train2p, @train3p]
    end

    def wagons
      [@wagon101c, @wagon102c, @wagon103c, @wagon104p, @wagon105p]
    end

    def routes
      [@route1, @route2]
    end
  end
end
