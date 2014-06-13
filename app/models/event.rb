class Event

  def initialize(event_listener)
    event_listener.notify(self) if event_listener
  end

  def game_over?; false; end
  def player_killed?; false; end
end
