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
    type = "Тип вагона: #{type}. "

    is_attached ? "Вагон прикреплен к поезду: #{@number}.\n#{type}" : "Вагон не прикреплен к поезду.\n#{type}"
  end
end
