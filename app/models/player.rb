class Player

  delegate :max_health, to: :character

  attr_reader :in_play, :health, :brain, :role, :character
  def initialize(role, character)
    @role = role
    @character = character
  end

  def sheriff?
    role == "sheriff"
  end

  def hand_size
    hand.size
  end

  def target_with(player, card)

  end

  def target_of(card)
    return false if barrel(card)
    brain.target_of(card)
  end

  def barrel(card)
    if card.barrelable?
      return deck.draw!.barreled?
    end
    false
  end

  def hit!
    #TODO char ability
    health--
    if dead?
      # TODO play a beer
    else
      PlayerKilledEvent.new(self)
    end
  end

  def dead?
    health <= 0
  end

  def play
    dynamite
    return if dead?
    return if jail
    draw
    brain.play
    brain.discard if hand.size > hand_limit
  end

  def dynamite
    dynamite_card = in_play.detect{ |card| card.type = Card.dynamite_card }
    if dynamite_card
      in_play.delete(dynamite_card)
      if deck.draw!.explode?
        3.times { hit!  }
      else
        left[1].in_play << dynamite_card
      end
    end
  end

  def jail
    jail_card = in_play.detect{ |card| card.type = Card.jail_card }
    if jail_card
      deck.discard << jail_card
      in_play.delete(jail_card)
      return true if deck.draw!.still_in_jail?
    end
    false
  end

  def draw
    if character.special_draw?
      brain.draw
    else
      hand << deck.take(character.draws)
    end
  end

  def jailed?
    in_play?(Card.jail)
  end

  def has?(card)
    hand.include?(card)
  end

  def in_play?(card)
    in_play.include?(card)
  end

  def hand_limit
    #TODO handle that character with a constant 10 card limit
    health
  end
end
