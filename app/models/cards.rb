## Dodge City
class SpringfieldCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
# Dodge City
class PunchCard < Card
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
class BangCard < Card
  def gun_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
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
      target_player.target_of_indians(self, player)
      target_player = target_player.left
    end
  end
end
class DuelCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of_duel(self, player)
  end
end
class GatlingCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    target_player = player.left

    while target_player != player
      target_player.target_of_bang(BangCard.new(self.suit, self.number), player)
      target_player = target_player.left
    end
  end
end
class MissedCard < Card
  def play(player=nil, target_player=nil, target_card=nil)
  end
end
class JailCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    raise ArgumentError, "Cannot Jail Sheriff" if target_player.sheriff?
    target_player.in_play << self
  end
end
class EquipmentCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    player.in_play << self
  end
end
class GunCard < EquipmentCard
  def no_range?;false;end
end
class DynamiteCard < EquipmentCard; end
class BarrelCard < EquipmentCard; end
class ScopeCard < EquipmentCard; end
#Dodge City
class BinocularsCard < EquipmentCard; end
class MustangCard < EquipmentCard; end
#Dodge City
class HideoutCard < EquipmentCard; end
class RevCarbineCard < GunCard
  def range; 4; end
end
class RemingtonCard < GunCard
  def range; 3; end
end
class SchofieldCard < GunCard
  def range; 2; end
end
class WinchesterCard < GunCard
  def range; 5; end
end
class VolcanicCard < GunCard
  def range; 1; end
end