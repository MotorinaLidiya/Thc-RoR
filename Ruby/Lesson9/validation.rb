require_relative 'output'

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, *params)
      @validations_hash ||= {}
      @validations_hash[attr_name.to_sym] ||= {}
      @validations_hash[attr_name.to_sym][validation_type.to_sym] = params.empty? ? true : params
    end

    def validations_hash
      @validations_hash ||= {}
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations_hash.each do |attr_name, validation_type|
        value = send(attr_name)

        errors = []
        errors << 'Значение атрибута nil или пустая строка' if check_presence(validation_type[:presence], value)
        if check_format(validation_type[:format], value)
          msg = validation_type[:format][1] || 'Значение атрибута не соответствует заданному регулярному выражению'
          errors << msg
        end
        errors << 'Значение атрибута не соответствует заданному классу' unless check_type(validation_type[:type], value)

        Output.error "#{errors.join('. ')}." unless errors.empty?
      end

      true
    end

    def valid?
      validate!
      true

    rescue Output
      false
    end

    private

    def check_presence(exists_presence_validation, value)
      return unless exists_presence_validation

      value.nil? || value == ''
    end

    def check_format(exists_format_validation, value)
      return unless exists_format_validation.first

      value !~ exists_format_validation.first
    end

    def check_type(exists_type_validation, value)
      return unless exists_type_validation.first

      value.is_a?(exists_type_validation.first)
    end
  end
end

# class Station
#   include Validation
#
#   attr_accessor :name
#
#   validate :name, :presence
#   validate :name, :format, /^[А-Я][а-я]+(-[А-Я][а-я]+)?$/i
#   validate :name, :type, String
# end
#
# class Train
#   include Validation
#
# end
#
# station = Station.new
#
# station.name = 'Поезда'
# p station.valid?
# p station.validate!
