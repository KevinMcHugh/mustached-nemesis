class Game
  attr_reader :deck, :players, :over, :event_listener, :round

  def initialize(players, deck)
    @players = players
    @deck = deck
    @event_listener = EventListener.new(self)
    event_listener.subscribe(self)
    @players.each { |p| p.event_listener = event_listener }

    @logger = Logger.new(Rails.root.join("log", "game.log"))
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
          @round += 1 if player.sheriff?
          @logger.info("#{player.class} #{player.health} #{player.role}")
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
