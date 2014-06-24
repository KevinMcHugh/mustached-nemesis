module Equip

  def equip(card, target_player=nil)
    if card.type == Card.jail_card
      target = target_player
    else
      target = self
    end
    if card.gun?
      duplicate_card = target.in_play.find(&:gun?)
      Event.new(event_listener, self, card, target_player, duplicate_card)
      discard(duplicate_card, true) if duplicate_card
    else
      duplicate_card = target.from_play(card.type)
      raise DuplicateCardPlayedException.new(card.type) if duplicate_card
      Event.new(event_listener, self, card, target_player)
    end
    target.in_play << card
    hand.delete(card)
  end

  class Event < ::Event
    attr_reader :player, :card, :target_player, :duplicate_card
    def initialize(event_listener, player, card, target_player, duplicate_card = nil)
      @player = player
      @card = card
      @target_player = target_player
      @duplicate_card = duplicate_card
      super(event_listener)
    end

    def to_s
      if card.type == Card.jail_card
        "#{player.class} jailed #{target_player.class}"
      elsif duplicate_card
        "#{player.class} equipped #{card.class}, instead of #{duplicate_card.class}"

      else
        "#{player.class} equipped #{card.class}"
      end
    end
  end
end
