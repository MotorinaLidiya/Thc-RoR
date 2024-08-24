# Пользователь вводит 3 коэффициента a, b и с.
# Программа вычисляет дискриминант (D) и корни уравнения (x1 и x2, если они есть) и выводит значения дискриминанта
# и корней на экран. При этом возможны следующие варианты:
#   Если D > 0, то выводим дискриминант и 2 корня
#   Если D = 0, то выводим дискриминант и 1 корень (т.к. корни в этом случае равны)
#   Если D < 0, то выводим дискриминант и сообщение "Корней нет"

p 'Введите 3 коэффициента: '
a = gets.to_f
b = gets.to_f
c = gets.to_f

D = b**2 - (4 * a * c)

if D.positive?
  x1 = (-b + Math.sqrt(D)) / (2 * a)
  x2 = (-b - Math.sqrt(D)) / (2 * a)
  p "Дискриминант : #{D}, корни: #{x1}, #{x2}!"
elsif D.zero?
  x1 = -b / (2 * a)
  p "Дискриминант равен нулю, корень: #{x1}!"
else
  p "Дискриминант отрицательный: #{D}, корней нет!"
end