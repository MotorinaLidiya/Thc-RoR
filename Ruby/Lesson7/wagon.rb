require_relative 'company_name'

class Wagon
  include CompanyName

  attr_reader :type
  attr_accessor :is_attached

  def initialize(type, total_place)
    @type = type
    @is_attached = false
    @total_place = total_place
    @used_place = 0
  end

  def free_place
    @total_place - @used_place
  end

  def to_s
    puts "Тип вагона: #{type}. "

    is_attached ? "Вагон прикреплен к поезду: #{@number}. " : 'Вагон не прикреплен к поезду. '
  end
end
