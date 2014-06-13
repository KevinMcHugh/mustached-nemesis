class EventListener
  attr_reader :game, :subscribers

  def initialize(game)
    @game = game
    @subscribers = []
    @logger = Logger.new(Rails.root.join("log", "game.log"))
  end

  def subscribe(subscriber)
    subscribers << subscriber
  end

  def notify(event)
    @logger.info(event.class)
    if event.player_killed?
      if event.killed.sheriff? || sheriff_win?
        GameOverEvent.new(self, event)
      end
    end
    subscribers.each {|sub| sub.notify(event)}
  end


  def sheriff_win?
    living_players = game.players.reject(&:dead?)
    roles = living_players.map(&:role)
    !(roles.include?('outlaw') || roles.include?('renegade'))
  end
end

class GameOverEvent < Event
  attr_reader :player_killed_event
  def initialize(event_listener, player_killed_event)
    @player_killed_event = player_killed_event
    super(event_listener)
  end
  def game_over?; true; end
end
