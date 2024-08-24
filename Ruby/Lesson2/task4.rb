# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
# a, e, i, o, u, y

def position(letters)
  letters.ord - 'a'.ord + 1
end

a = position('a')
e = position('e')
i = position('i')
y = position('y')
u = position('u')
o = position('o')
hash = { a: a, e: e, i: i, o: o, u: u, y: y}

puts hash
