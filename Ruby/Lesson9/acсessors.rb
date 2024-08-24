# {
#   attribute_name1: {history: true, strong: true, class_name: String},
#   attribute_name2: {history: true},
#   attribute_name3: {strong: true, class_name: String},
# }
require_relative 'output'

module Accessors
  def attr_accessor_with_history(*attributes)
    attributes.each do |attr|
      update_attr_hash(attr, :history)
      define_attr_accessor(attr)
    end
  end

  def strong_attr_accessor(attr, attr_class)
    update_attr_hash(attr, :strong)
    update_attr_hash(attr, :class_name, attr_class)

    define_attr_accessor(attr)
  end

  private

  def update_attr_hash(attr, accessor_type, value = true)
    @@attr_hash ||= {}
    @@attr_hash[attr.to_sym] ||= {}
    @@attr_hash[attr.to_sym][accessor_type] = value
  end

  def define_attr_accessor(attr)
    var_attr = "@#{attr}".to_sym

    define_method(attr) { instance_variable_get(var_attr) }

    define_method("#{attr}=") do |value|
      options = @@attr_hash[attr.to_sym]

      Output.error 'Имя атрибута не соответствует указанному классу. ' if options[:strong] && !value.is_a?(options[:class_name])
      Output.error 'Атрибут должен состоять из строчных английских букв, цифр и "_". ' if attr !~ /^[a-z0-9_]+$/i

      instance_variable_set(var_attr, value)
      puts @@attr_hash
      if options[:history]
        eval("@#{attr}_attr_history ||= []")
        eval("@#{attr}_attr_history << value")
        define_singleton_method("#{attr}_history") { print instance_variable_get("@#{attr}_attr_history") }
      end
    end
  end
end

# class MyClass
#   extend Accessors
#
#   attr_accessor_with_history :name, :age, :gender
#   strong_attr_accessor :age, Integer
#   strong_attr_accessor :name, String
#   strong_attr_accessor :gender, String
# end
#
# class Test
#   extend Accessors
#
#   attr_accessor_with_history :name, :age, :hair_color
#   strong_attr_accessor :age, Integer
#   strong_attr_accessor :name, String
#   strong_attr_accessor :gender, String
# end
#
# obj = MyClass.new
#
# obj.name = 'Olly'
# obj.name = 'Ben'
# obj.age = 25
# obj.age = 30
# obj.gender = 'male'
# obj.gender = 'female'
#
# object = Test.new
#
# object.name = 'Olly'
# object.name = 'Anya'
# object.age = 30
# object.age = 20
# object.gender = 'male'
# object.gender = 'female'
#
# puts obj.name_history
# puts obj.age_history
# puts obj.gender_history
# puts object.name_history
# puts object.age_history
