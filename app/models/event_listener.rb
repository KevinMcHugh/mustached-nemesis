class EventListener
  attr_reader :game, :subscribers

  def initialize(game)
    @game = game
    @subscribers = []
    @logger = MonoLogger.new
  end

  def subscribe(subscriber)
    subscribers << subscriber
  end

  def notify(event)
    @logger.info(event.to_s)
    subscribers.each {|sub| sub.notify(event)}
    if event.player_killed?
      if event.sheriff_killed? || sheriff_win?
        GameOverEvent.new(self, game) #TODO double renegades
      end
    elsif event.game_over?
      @logger.close
    end
  end

  def sheriff_win?
    living_players = game.living_players
    roles = living_players.map(&:role)
    !(roles.include?('outlaw') || roles.include?('renegade'))
  end
end

