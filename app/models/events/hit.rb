module Hit
  def hit!(hitter=nil)
    @health -= 1
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
    attr_reader :player, :hitter, :health
    def initialize(event_listener, player, hitter)
      @player = player
      @health = player.health
      @hitter = hitter
      super(event_listener)
    end

    def to_s
      from = hitter ? hitter.class : DynamiteCard.killer
      ["#{player.class} hit by #{from}, at #{health}", "#{player.class} has dropped down to #{health} because of #{from}",
       "#{player.class} is feelin' the pain at #{health}, thanks to #{from}"].sample
    end
  end
end
