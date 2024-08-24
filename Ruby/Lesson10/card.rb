class Card
  attr_reader :value, :suit, :type

  def initialize(value, suit, type)
    @value = value
    @suit = suit
    @type = type
  end

  def to_s
    "[#{@type}#{@suit}]"
  end
end
