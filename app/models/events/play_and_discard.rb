module PlayAndDiscard

  def play_and_discard(card, target_player=nil, target_card=nil)
    if card.type == Card.bang_card
      @bangs_played +=1
    end
    raise TooManyBangsPlayedException.new if over_bang_limit? && card.type == Card.bang_card
    Event.new(event_listener, self, card, target_player, target_card)

    if in_range?(card, target_player)
      discard(card, true)
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
      if card.type == Card.beer_card
        return ["#{player.class} is enjoying a nice cold Miller® Lite®. It's Miller® Time®!",
          "#{player.class} is sipping an ice cold Coors® Light®. Taste the Rockies®!",
          "#{player.class} playing and discarding #{card.type}"].sample
      end
      string = "#{player.class} playing and discarding #{card.type}"
      if target_player && card.targets_players?
        string += " at #{target_player.class}"
        if card.targets_cards?
          if target_card.is_a? Symbol
            string += "'s #{target_card}"
          else
            string += "'s #{target_card.type}"
          end
        end
      end
      string
    end
  end
end
