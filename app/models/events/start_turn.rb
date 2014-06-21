module StartTurn

  def start_turn
    Event.new(event_listener, self)
  end


  class Event < ::Event
    attr_reader :player, :in_play, :hand, :player_string
    def initialize(event_listener, player)
      @player = player
      @player_string = player.to_s
      @in_play = player.in_play.map(&:class)
      @hand = player.hand.map(&:class)
      super(event_listener)
    end

    def to_s
      "#{player_string} starting turn.\n In play: #{in_play}\n In hand: #{hand}"
    end

    def as_json(options={})
      {:@type => self.class, :@player => player.as_json}
    end
  end

end
