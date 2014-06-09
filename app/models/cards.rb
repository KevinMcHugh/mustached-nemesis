class SpringfieldCard < Card
  def play(player, target_player, target_card:nil)
    target_player.target_of(self, player)
  end
end
class PunchCard < Card
  def play(player, target_player, target_card:nil)
    target_player.target_of(self, player)
  end
end
class BangCard < Card
  def play(player, target_player, target_card:nil)
    target_player.target_of(self, player)
  end
end
class BeerCard < Card
  def play(player, target_player:nil, target_card:nil)
    player.heal(player.beer_benefit)
  end
end