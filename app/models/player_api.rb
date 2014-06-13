class PlayerAPI

  def initialize(player, brain)
    @player = player
    @brain = brain
    @dtos_to_players = Hash.new { |hash, key| hash[key] = find_player(key)}
  end

  def from_hand(card_type)
    player.from_hand(card_type)
  end

  def play_card(card, target_player=nil, target_card=nil)
    if target_player
      target_player = dtos_to_players[target_player]
    end
    player.play_and_discard(card,target_player, target_card)
  end

  def hand
    player.hand.clone
  end

  def players
    players = []
    next_player = player.left
    while next_player != player
      players << PlayerDTO.new(next_player, player)
      next_player = next_player.left
    end
    players
  end

  def players_in_range_of(card)
    players.find_all { |p| player.in_range?(card, dtos_to_players[p])}
  end

  def health; player.health; end

  private
  attr_reader :player, :brain, :dtos_to_players

  def find_player(player_dto)
    target_player = nil
    p = player.left
    while !target_player
      target_player = p if p.class == player_dto.name
      p = p.left
    end
    target_player
  end
end
