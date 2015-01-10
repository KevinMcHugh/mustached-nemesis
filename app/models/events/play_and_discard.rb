module PlayAndDiscard

  def play_and_discard(card, target_player=nil, target_card=nil)
    @bangs_played +=1 if counts_as_bang?(card)
    raise TooManyBangsPlayedException.new if over_bang_limit? && counts_as_bang?(card)
    Event.new(event_listener, self, card, target_player, target_card)

    if in_range?(card, target_player)
      discard(card, true)
      play_card(card, target_player, target_card)
    else
      raise OutOfRangeException.new
    end
  end

  def counts_as_bang?(card)
    card.type == Card.bang_card
  end

  def play_card(card, target_player, target_card)
    card.play(self, target_player, target_card)
  end

  class Event < ::Event
    is_voluntary
    attr_reader :card, :target_player, :target_card
    def initialize(event_listener, player, card, target_player, target_card)
      @player        = player
      @card          = card
      @target_player = target_player
      @target_card   = target_card
      @target        = target_player
      super(event_listener)
    end

    def to_s
      if card.type == Card.beer_card
        return card.message(player)
      end
      string = "#{player.class} playing and discarding #{card.type}"
      if target_player && card.targets_players?
        string += " at #{target_player.class}"
        if card.targets_cards?
          if target_card.is_a? Symbol
            string += "'s #{target_card}"
          else
            string += "'s #{target_card}"
          end
        end
      end
      string
    end
  end
end
