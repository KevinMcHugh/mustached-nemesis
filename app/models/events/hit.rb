module Hit
  def hit!(hitter=nil)
    @health -= 1 if @health > 0
    Event.new(event_listener, self, hitter)
    if dead?
      beer
      if dead? #The beer *may* have brought you back to life.
        PlayerKilledEvent.new(event_listener, self, hitter)
        raise PlayerKilledException.new
      end
    end
  end

  class Event < ::Event
    attr_reader :player, :hitter
    def initialize(event_listener, player, hitter)
      @player = player
      @hitter = hitter
      super(event_listener)
    end

    def to_s
      "#{player.class} hit by #{hitter.class}, at #{player.health}"
    end
  end
end
