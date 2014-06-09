class Card
  MISSABLE = %w{ bang! punch springfield gatling }
  attr_accessor :suit, :number, :type

  def initialize(suit, number, type)
    @suit = suit
    @number = number
    @type = type
  end

  def play(player, target_player:nil, taget_card:nil)
    player.discard(self)
  end

  def barrelable?
    MISSABLE.include?(type)
  end

  def explode?
    number >= 2 && number <= 9 && suit == "spade"
  end

  def still_in_jail?
    suit != "heart"
  end
end