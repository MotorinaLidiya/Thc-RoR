require_relative 'company_name'

class Wagon
  include CompanyName

  attr_reader :type
  attr_accessor :is_attached

  def initialize(type)
    @type = type
    @is_attached = false
  end

  def to_s
    puts "Тип вагона: #{self.class::TYPE}."

    self.is_attached ? "Вагон прикреплен к поезду: #{@number}" : 'Вагон не прикреплен к поезду'
  end
end
