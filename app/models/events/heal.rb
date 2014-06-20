module Heal
  def heal(regained_health=1)
    Event.new(event_listener, self)
    regained_health.times { @health += 1 if health < max_health }
  end

  class Event < ::Event
    attr_reader :player
    def initialize(event_listener, player)
      @player = player
      super(event_listener)
    end

    def to_s
      "#{player.class} healed up to #{player.health}"
    end
  end
end
