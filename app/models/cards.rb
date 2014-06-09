class SpringfieldCard < Card
  def no_range?;true;end
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
  def gun_range?;true;end
  def play(player, target_player, target_card:nil)
    target_player.target_of(self, player)
  end
end
class BeerCard < Card
  def no_range?;true;end
  def play(player, target_player:nil, target_card:nil)
    player.heal(player.beer_benefit)
  end
end