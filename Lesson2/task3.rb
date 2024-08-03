# Заполнить массив числами фибоначчи до 100
# 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89

arr = [0, 1]
number = 0

while number < 100
  arr << number
  number = arr[-1] + arr[-2]
end

puts arr
