module TapBadge

  def tap_badge(adverb='intently')
    Event.new(event_listener, self, adverb)
  end


  class Event < ::Event
    attr_reader :player, :adverb
    def initialize(event_listener, player, adverb)
      @player = player
      @adverb = adverb
      super(event_listener)
    end

    def to_s
      @player.sheriff? ? "#{player.class} taps its badge #{adverb}" :
        "#{player.class} attempts to tap its badge, does not realize that it does not have a badge,
            and makes a fool of itself in front of all the other robots."
    end
  end
end
