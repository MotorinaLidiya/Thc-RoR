# Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
# Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.
# На основе введенных данных требуетеся:
# Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш,
# содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
# Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".

hash = {}
total_price = {}

loop do
  p 'Please enter item name: '
  item_name = gets.chomp
  break if item_name == 'stop'

  p 'Please enter price: '
  item_price = gets.to_f
  p 'Please enter quantity of items: '
  item_quantity = gets.to_f

  hash[item_name] = { price: item_price, quantity: item_quantity }
  total_price[item_name] = item_price * item_quantity
end

p hash
p total_price
p total_price.values.sum
