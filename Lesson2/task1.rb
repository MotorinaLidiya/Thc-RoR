# Сделать хеш, содержащий месяцы и количество дней в месяце.
# В цикле выводить те месяцы, у которых количество дней ровно 30

months = { jan: 31, feb: 28, mar: 31, apr: 30, may: 31, jun: 30, jul: 31, aug: 31, sept: 30, oct: 31, nov: 30, dec: 31 }

months.each do |key, value|
  puts key if value == 30
end
