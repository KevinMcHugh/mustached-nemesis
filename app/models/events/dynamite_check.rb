module DynamiteCheck

  def dynamite
    dynamite_card = from_play(Card.dynamite_card)
    if dynamite_card
      if draw!(:dynamite).explode?
        Event.new(event_listener, self, true)
        discard(dynamite_card)
        3.times { hit!  }
      else
        Event.new(event_listener, self, false)
        in_play.delete(dynamite_card)
        next_player = left
        while next_player.left.from_play(Card.dynamite_card)
          next_player = next_player.left
        end
        next_player.in_play << dynamite_card
      end
    end
  end

  class Event < ::Event
    attr_reader :player, :blown_up
    def initialize(event_listener, player, blown_up)
      @player = player
      @blown_up = blown_up
      super(event_listener)
    end

    def to_s
      blown_up ? "#{player.class} was blown up!" :
        "#{player.class} was not blown up"
    end
  end
end
