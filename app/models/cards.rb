## Brown Cards:
class BangCard < Card
  def gun_range?;true;end
  def damage_dealing?; true; end
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
class BeerCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    return if player.players.size == 1
    player.heal(player.beer_benefit)
  end
end
class SaloonCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    player.heal(1)
    player.players.map(&:heal)
  end
end
class StageCoachCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    2.times{ player.draw }
  end
end
class WellsFargoCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    3.times { player.draw }
  end
end
class IndiansCard < Card
  def no_range?;true;end
  def damage_dealing?; true; end
  def play(player, target_player=nil, target_card=nil)
    target_player = player.left

    while target_player != player
      target_player.target_of_indians(self, player)
      target_player = target_player.left
    end
  end
end
class PanicCard < Card
  def range; 1; end
  def play(player, target_player, target_card)
    if target_card == :hand
      card = target_player.random_from_hand
      player.hand << card if card
    else
      card = target_player.from_play(target_card)
      target_player.in_play.delete(target_card)
      player.hand << card if card
    end
  end
end
class GeneralStoreCard < Card
  def no_range?; true; end
  def play(player, target_player=nil, target_card=nil)
    players = [player]
    players += player.players
    cards = player.deck.take(players.count)
    players.each do |p|
      card = p.brain.pick(1, cards)
      p.hand += card
      cards.delete(card)
    end
  end
end
class CatBalouCard < Card
  def no_range?; true; end
  def play(player, target_player, target_card)
    if target_card == :hand
      card = target_player.random_from_hand
      target_player.discard(target_player.random_from_hand) if card
    else
      card = target_player.from_play(target_card)
      target_player.discard(card) if card
    end
  end
end
class DuelCard < Card
  def no_range?;true;end
  def damage_dealing?; true; end
  def play(player, target_player, target_card=nil)
    target_player.target_of_duel(self, player)
  end
end
class GatlingCard < Card
  def no_range?;true;end
  def damage_dealing?; true; end
  def play(player, target_player=nil, target_card=nil)
    target_player = player.left

    while target_player != player
      target_player.target_of_bang(self, player)
      target_player = target_player.left
    end
  end
end
class MissedCard < Card
  def play(player=nil, target_player=nil, target_card=nil)
  end
end



## Blue Cards:
class EquipmentCard < Card
  def no_range?;true;end
  def equipment?;true; end
  def play(player, target_player=nil, target_card=nil); end
end
class JailCard < EquipmentCard
  def no_range?;true;end
  def equipment?;true; end
  def play(player, target_player, target_card=nil)
    raise ArgumentError, "Cannot Jail Sheriff" if target_player.sheriff?
    target_player.in_play << self
  end
end
class DynamiteCard < EquipmentCard
  def damage_dealing?; true; end
end
class BarrelCard < EquipmentCard; end
class ScopeCard < EquipmentCard; end
class MustangCard < EquipmentCard; end
class GunCard < EquipmentCard
  def no_range; false; end
  def type; GunCard; end
end
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

## Dodge City
class HideoutCard < EquipmentCard; end
class BinocularsCard < EquipmentCard; end
class SpringfieldCard < Card
  def no_range?;true;end
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
class PunchCard < Card
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
