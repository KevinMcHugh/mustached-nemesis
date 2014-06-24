module NewTurnStarted

  def new_turn_started
    Event.new(event_listener, self)
  end

  class Event < ::Event
    attr_reader :player, :in_play, :hand, :player_string
    def initialize(event_listener, player)
      @player = player
      @player_string = player.to_s
      @in_play = map(player.in_play)
      @hand = map(player.hand)
      super(event_listener)
    end

    def to_s
      "#{player_string} starting turn.\n In play: #{in_play}\n In hand: #{hand}"
    end

    def as_json(options={})
      {:@type => self.class.to_s, :@player => player.as_json,
        :@hand => hand, :@in_play => in_play}
    end

    private
    def map(array)
      array.map(&:class).flat_map(&:to_s)
    end
  end
end
