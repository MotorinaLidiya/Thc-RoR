# Программа запрашивает у пользователя 3 стороны треугольника и определяет, является ли треугольник прямоугольным
# (используя теорему Пифагора www-formula.ru), равнобедренным (т.е. у него равны любые 2 стороны)  или равносторонним
# (все 3 стороны равны) и выводит результат на экран.
# Подсказка: чтобы воспользоваться теоремой Пифагора, нужно сначала найти самую длинную сторону (гипотенуза)
# и сравнить ее значение в квадрате с суммой квадратов двух остальных сторон.
# Если все 3 стороны равны, то треугольник равнобедренный и равносторонний, но не прямоугольный.
# (принято считать, что если 3 стороны равны, треугольник все-таки равносторонний :))

p 'Please print 3 sides of a triangle: '
a = gets.to_f
b = gets.to_f
c = gets.to_f

arr = [a, b, c]
squared_arr = arr.map { |i| i**2 }

max_side = squared_arr.max
squared_arr.delete(max_side)

if a == b && a == c
  p 'The triangle is equilateral'
elsif a == b || a == c || b == c
  p 'The triangle is isosceles'
elsif max_side == squared_arr.sum
  p 'The triangle is rectangular'
else
  p 'The triangle is normal'
end
