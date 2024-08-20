class Output < StandardError
  class << self
    def with_rescue
      yield
    rescue Output => e
      puts e
      sleep 1
      retry
    end

    def error(message)
      raise new(message)
    end

    def select_item(collection)
      collection.each_with_index { |item, index| puts "#{index + 1}. #{item} "}

      with_rescue do
        puts 'Введите exit для выхода из действия'
        item_name = string_choice('Введите название нужного объекта: ')

        return if item_name == 'exit'

        item = collection.find { |i| i.name == item_name }

        Output.error 'Нет информации о введенных данных. ' unless item

        item
      end
    end

    def string_choice(output)
      puts output.to_s
      gets.chomp
    end

    def number_choice(output)
      puts output.to_s
      gets.chomp.to_i
    end
  end
end
