class Player

  Role.all_roles.each do |r|
    define_method("#{r}?") { r == role}
  end

  delegate :max_health, to: :character

  def hit!
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
    dynamite = in_play.detect{ |card| card.type = Card.dynamite }
    if dynamite
      in_play.delete(dynamite)
      if deck.draw!.explode?
        3.times { hit!  }
      else
        left[1].in_play << dynamite
      end
    end
    return if dead?
    jail = in_play.detect{ |card| card.type = Card.jail }
    if jail
      deck.discard << jail
      in_play.delete(jail)
      return if deck.draw!.still_in_jail?
    end
    brain.draw
    brain.play
    brain.discard if hand.size > hand_limit
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
