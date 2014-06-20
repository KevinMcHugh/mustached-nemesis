module PlayAndDiscard

  def play_and_discard(card, target_player=nil, target_card=nil)
    if card.type == Card.bang_card
      @bangs_played +=1
    end
    raise TooManyBangsPlayedException.new if over_bang_limit? && card.type == Card.bang_card
    Event.new(event_listener, self, card, target_player, target_card)

    if in_range?(card, target_player)
      discard(card)
      card.play(self, target_player, target_card)
    else
      raise OutOfRangeException.new
    end
  end

  class Event < ::Event
    attr_reader :player, :card, :target_player, :target_card
    def initialize(event_listener, player, card, target_player, target_card)
      @player = player
      @card = card
      @target_player = target_player
      @target_card = target_card
      super(event_listener)
    end

    def to_s
      if target_player
        if card.targets_cards?
          if target_card.is_a? Symbol
            "#{player.class} playing #{card.class} at #{target_player.class}'s #{target_card}"
          else
            "#{player.class} playing #{card.class} at #{target_player.class}'s #{target_card.class}"
          end
        else
          "#{player.class} playing #{card.class} at #{target_player.class}"
        end
      else
        "#{player.class} playing #{card.class}"
      end
    end
  end
end
