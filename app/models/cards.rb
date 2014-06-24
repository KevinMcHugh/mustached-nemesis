## Brown Cards:
class BangCard < Card
  def gun_range?;true;end
  def damage_dealing?; true; end
  def targets_players?; true; end
  def play(player, target_player, target_card=nil)
    target_player.target_of_bang(self, player)
  end
end
class BeerCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    if player.players.size >= 1
      player.heal(player.beer_benefit)
    end
  end
end
class SaloonCard < Card
  def no_range?;true;end
  def play(player, target_player=nil, target_card=nil)
    player.heal(1)
    other_players(player, &:heal)
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
    other_players(player) { |p| p.target_of_indians(self, player)}
  end
end
class PanicCard < Card
  def range; 1; end
  def targets_cards?; true; end
  def targets_players?; true; end
  def play(player, target_player, target_card)
    if target_card == :hand
      card = target_player.random_from_hand
      player.give_card(card) if card
    else
      card = target_player.from_play(target_card)
      target_player.in_play.delete(target_card)
      player.give_card(card) if card
    end
  end
end
class GeneralStoreCard < Card
  def no_range?; true; end
  def play(player, target_player=nil, target_card=nil)
    players = [player]
    players += player.players
    cards = player.deck.take(players.count)
    #TODO event for this
    # player.log("General Store's army has arrived in town! #{cards.map(&:to_s)}")
    players.each do |p|
      card_dto = p.brain.pick(1, cards.map(&:to_dto)).first
      card = cards.find { |c| card_dto == c.to_dto}

      # p.log("#{p.class} picked #{card.to_s}")
      p.give_card(card) if card
      cards.delete_if { |c| c === card }
    end
  end
end
class CatBalouCard < Card
  def no_range?; true; end
  def targets_players?; true; end
  def targets_cards?; true; end
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
  def targets_players?; true; end
  def play(player, target_player, target_card=nil)
    target_player.target_of_duel(self, player)
  end
end
class GatlingCard < Card
  def no_range?;true;end
  def damage_dealing?; true; end
  def play(player, target_player=nil, target_card=nil)
    other_players(player) { |p| p.target_of_bang(self, player)}
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
  def self.killer; 'DYNAMITE, CATS AND KITTENS'; end
end
class BarrelCard < EquipmentCard; end
class ScopeCard < EquipmentCard; end
class MustangCard < EquipmentCard; end
class GunCard < EquipmentCard
  def no_range; false; end
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
