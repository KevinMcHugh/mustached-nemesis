class BeerCard < Beer

  def play(player, target_player:nil, target_card:nil)
    player.heal(1)
    super(player, target_player: target_player, target_card: target_card)
  end

end