class EventListener
  attr_reader :game, :subscribers

  def initialize(game, logger)
    @game = game
    @subscribers = []
    @logger = logger
  end

  def subscribe(subscriber)
    subscribers << subscriber
  end

  def notify(event)
    @logger.info(event.to_s)
    subscribers.each {|sub| sub.notify(event)}
    if event.player_killed?
      if event.killed.sheriff? || sheriff_win?
        GameOverEvent.new(self, event, game) #TODO double renegades
      end
    end
  end

  def sheriff_win?
    living_players = game.living_players
    roles = living_players.map(&:role)
    !(roles.include?('outlaw') || roles.include?('renegade'))
  end
end

