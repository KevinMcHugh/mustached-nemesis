class PlayerAPI

  def initialize(player, brain)
    @player = player
    @brain = brain
  end

  def from_hand(card_type)
    player.from_hand(card_type)
  end

  def play_card(card, target_)
    player.play_and_discard(card)
  end

  def hand
    player.hand.clone
  end

  def players
    players = []
    next_player = player.left
    while(next_player != player)
      players << PlayerDTO.new(next_player, player)
      next_player = player.left
    end
    players
  end

  private
  attr_reader :player, :brain
end
