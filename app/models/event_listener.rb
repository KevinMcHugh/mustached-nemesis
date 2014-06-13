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
    @logger.info(event.to_s)
    if event.player_killed?
      if event.killed.sheriff? || sheriff_win?
        GameOverEvent.new(self, event, game)
      end
    end
    subscribers.each {|sub| sub.notify(event)}
  end

  def sheriff_win?
    living_players = game.living_players
    roles = living_players.map(&:role)
    !(roles.include?('outlaw') || roles.include?('renegade'))
  end
end

class GameOverEvent < Event
  attr_reader :player_killed_event, :game
  def initialize(event_listener, player_killed_event, game)
    @player_killed_event = player_killed_event
    @game = game
    super(event_listener)
  end

  def winner
    living_players = game.living_players
    if living_players.find { |p| p.sheriff?}
      'the forces of law have'
    elsif living_players.map(&:role) == ['renegade']
      'the renegade has'
    else
      'the outlaws have'
    end
  end

  def to_s
    "#{winner} prevailed in #{game.round} rounds!\n The following people are still alive: #{game.living_players.map(&:to_s)}"
  end
  def game_over?; true; end
end
