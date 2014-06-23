module Heal
  def heal(regained_health=1)
    regained_health.times { @health += 1 if health < max_health }
    Event.new(event_listener, self)
  end

  class Event < ::Event
    attr_reader :player, :health
    def initialize(event_listener, player)
      @player = player
      @health = player.health
      super(event_listener)
    end

    def to_s
      "#{player.class} healed up to #{health}"
    end
  end
end
