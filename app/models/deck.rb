class Deck

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
    check_to_shuffle.pop(number_of_cards)
  end

  def draw!
    card = check_to_shuffle.pop
    discard.push(card)
    card
  end

  def check_to_shuffle
    return draw unless draw.empty?
    draw += discard.shuffle
    discard.clear
    draw
  end

  private
  attr_reader :draw, :discard
end
