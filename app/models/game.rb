class Game
  attr_reader :deck, :players, :over, :event_listener, :round, :winners

  def initialize(players, deck)
    @players = players
    @deck = deck
    @logger = MonoLogger.new
    @event_listener = EventListener.new(self, @logger)
    event_listener.subscribe(self)
    @players.each { |p| p.event_listener = event_listener }
    @players.each { |p| p.logger = @logger }

    @logger.info("STARTING A NEWWWWW GAMEEEEEE")
    @logger.info("YEEEEE-HAWWWWWWWWWWWWWWWWWWW")
    @logger.info("\n")
    @logger.info("\n")
    @logger.info("\n")
    @logger.info("\n")
  end

  def start
    deck.deal_to(players)
    @round = 0

    while !over do
      begin
        player = sheriff
        while true
          # paul regret, because he's 1 away, can cause stalemates against the dumb bots
          if round > 150
            @winners = []
            return
          end
          @round += 1 if player.sheriff?
          @logger.info("#{player.to_s}")
          player.play
          player = player.left
        end
      rescue GameOverException => e
      end
    end
  end

  def notify(event)
    if event.game_over?
      @over = true
      @winners = event.winners
      raise GameOverException.new
    end
  end

  def living_players
    players.reject(&:dead?)
  end

  private
  def sheriff
    @sheriff ||= players.find { |p| p.sheriff?}
  end


  def self.roles_for_players(number_of_players)
    all[0..number_of_players]
  end

  def self.all_roles
    %w{sheriff renegade outlaw outlaw
      deputy outlaw deputy renegade}
  end
end

class GameOverException < Exception
end
