# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.

p 'Please enter day: '
day = gets.to_i
p 'Please enter month: '
month = gets.to_i - 1
p 'Please enter year: '
year = gets.to_i

first_month = 0
year_days = 365
month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?
  year_days += 1
  month_days[1] += 1
end

result = month_days[first_month...month].sum
day_count = result + day

puts year_days
puts day_count
