class NewRoundStartedEvent < Event
  def initialize(event_listener, round)
    @round = round
    super(event_listener)
  end

  def to_s;
    "Round ##{@round} started."
  end
end
