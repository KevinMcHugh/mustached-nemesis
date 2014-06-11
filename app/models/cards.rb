## Dodge City
class SpringfieldCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of(self, player)
  end
end
# Dodge City
class PunchCard < Card
  def play(player, target_player, target_card=nil)
    target_player.target_of(self, player)
  end
end
class BangCard < Card
  def gun_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of(self, player)
  end
end
class BeerCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    player.heal(player.beer_benefit)
  end
end
class IndiansCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    target_player = player.left

    while target_player != player
      target_player.target_of(self, player)
      target_player = target_player.left
    end
  end
end
class GatlingCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    target_player = player.left

    while target_player != player
      target_player.target_of(BangCard.new(self.suit, self.number), player)
      target_player = target_player.left
    end
  end
end
class JailCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    raise ArgumentError, "Cannot Jail Sheriff" if target_player.sheriff?
    target_player.in_play << self
  end
end
class DynamiteCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    player.in_play << self
  end
end



