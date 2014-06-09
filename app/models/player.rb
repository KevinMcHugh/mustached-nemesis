# for each character, there should be a subclass of player
# that uses a refinement implementing that character's
# special ability. You have to create that subclass because
# `using` cannot be called from within a method. Blech.
#
# For `method`,  where `method` is subject to being overriden
# by a refinement, `method` should internally call `_method`,
# so that the refinement can use the original behavior without
# changing the API.

class Player
  delegate :max_health, to: :character

  attr_reader :in_play, :health, :brain, :role, :character, :deck

  def initialize(role, character)
    @role = role
    @character = character
  end

  def play
    dynamite
    return if dead?
    return if jail
    draw_for_turn
    brain.play
    brain.discard if hand.size > hand_limit
  end

  def sheriff?
    role == "sheriff"
  end

  def hand_size
    hand.size
  end

  def target_with(player, card)

  end

  def target_of(card, targetter)
    return false if barrel(card)
    hit = brain.target_of(card)
    hit!(targetter) if hit
  end

  def barrel(card)
    if card.barrelable?
      return deck.draw!.barreled?
    end
    false
  end

  def hit!(hitter)
    _hit!(hitter)
  end

  def _hit!(hitter=nil)
    health--
    if dead?
      beer
    else
      PlayerKilledEvent.new(self)
    end
  end

  def beer
    beer_card = from_hand(Card.beer)
    if beer_card
      play_and_discard(beer_card)
    end
  end

  def heal_one
    health += 1 if health < max_health
  end

  def dead?
    health <= 0
  end

  def dynamite
    dynamite_card = from_play(Card.dynamite)
    if dynamite_card
      if deck.draw!.explode?
        3.times { hit!  }
        discard(dynamite_card)
      else
        in_play.delete(dynamite_card)
        left[1].in_play << dynamite_card
      end
    end
  end

  def jail
    jail_card = from_play(Card.jail)
    if jail_card
      discard(jail_card)
      return true if deck.draw!.still_in_jail?
    end
    false
  end

  def jailed?
    in_play?(Card.jail)
  end

  private
  def from_play(card_type)
    in_play.detect { |card| card.type = card_type }
  end

  def from_hand(card_type)
    hand.detect { |card| card.type = card_type }
  end

  def discard(card)
    deck.discard << card
    in_play.delete(card)
  end

  def play_and_discard(card)
    _play_and_discard(card)
  end

  def _play_and_discard(card)
    card.play
    discard(card)
  end

  def hand_limit
    health
  end

  def draw_for_turn
    2.times { draw }
  end

  def draw
    hand << deck.take(1)
  end

  def beer_benefit; 1; end
end
