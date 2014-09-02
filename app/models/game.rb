class Game
  attr_reader :deck, :players, :over, :event_listener, :round, :winners, :events

  def initialize(players, deck)
    @players = players
    @deck = deck
    @event_listener = EventListener.new(self)
    event_listener.subscribe(self)
    @players.each { |p| p.event_listener = event_listener }
    @events = []
    @round = 0
    NewGameStartedEvent.new(event_listener)
  end

  def start
    deck.deal_to(players)
    player = sheriff
    while !over do
      begin
        if stalemated?
          @winners = []
          return
        end
        start_new_round if player.sheriff?
        player.play
        raise ArgumentError.new if error_state?(player)
        player = player.left
      rescue GameOverException => e
      rescue PlayerKilledException => e
        next if player.dead?
      end
    end
  end

  def notify(event)
    @events << event
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

  def self.all_roles
    %w{sheriff renegade outlaw outlaw
      deputy outlaw deputy renegade}
  end
  def error_state?(player)
    player == player.left || living_players.size == 1 ||
      player.players.size != living_players.size - 1 && !player.dead?
  end

  def start_new_round
    @round += 1
    NewRoundStartedEvent.new(event_listener, @round)
  end

  def stalemated?; round > 150; end
end

class GameOverException < Exception
end
