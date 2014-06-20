module Equip

  def equip(card, target_player=nil)
    if card.type == Card.jail_card
      target = target_player
    else
      target = self
    end
    duplicate_card = target.from_play(card.type)
    if duplicate_card
      if card.type == Card.gun_card
        discard(duplicate_card)
      else
        raise DuplicateCardPlayedException.new(card.type)
      end
    end
    Event.new(event_listener, self, card, target_player)
    target.in_play << card
    hand.delete(card)
  end

  class Event < ::Event
    attr_reader :player, :card, :target_player
    def initialize(event_listener, player, card, target_player)
      @player = player
      @card = card
      @target_player = target_player
      super(event_listener)
    end

    def to_s
      if card.type == Card.jail_card
        "#{player.class} jailed #{target_player.class}"
      else
        "#{player.class} equipped #{card.class}"
      end
    end
  end
end
