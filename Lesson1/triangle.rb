# Площадь треугольника можно вычислить, зная его основание (a) и высоту (h) по формуле: 1/2*a*h.
# Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.

p 'Lets find out the area of a triangle. Print the base of a triangle (a):'
a = gets.to_f

p 'Ok, now print the height of a triangle (h):'
h = gets.to_f

S = 0.5 * a * h

p "Area of triangle is #{S}"
