# Программа запрашивает у пользователя имя и рост и выводит идеальный вес по формуле (<рост> - 110) * 1.15,
# после чего выводит результат пользователю на экран с обращением по имени.
# Если идеальный вес получается отрицательным, то выводится строка "Ваш вес уже оптимальный"

p 'Please, print your name: '
name = gets.chomp

p 'Now print your height: '
height = gets.to_i

weight = (height - 110) * 1.15

if weight >= 0
  p "#{name}, your optimal weight is #{weight}"
else
  p "#{name}, your weight is already optimal"
end
