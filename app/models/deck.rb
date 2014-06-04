class Deck
  attr_reader :draw, :discard

  def initialize
    @draw = Card.all
    @discard = []
  end

  def deal_to(players)
    players.each do |player|
      player.give(take(player.max_health))
    end
  end

  def take(number_of_cards=1)
    draw.pop(number_of_cards)
  end

  def draw!
    card = draw.pop
    discard.push(card)
    card
  end
end
