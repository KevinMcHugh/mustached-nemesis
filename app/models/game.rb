class Game < ActiveRecord::Base
  attr_reader :deck, :players

  def initialize(players, deck)
    @players = players
    @deck = deck

  end

  def start
    @event_listener = EventListener.new(self)
    @event_listener.subscribe(self)

    @deck = Deck.new
    deck.deal_to(players)
    while !over do
      begin
        players.each do |player|
          player.play
        end
      rescue GameOverException => e
        e
      end
    end
  end

  def notify(event)
    if event.game_over?
      over = true
      raise GameOverException.new
    end
  end

  private
  def sheriff
    @sheriff ||= players.find { |p| p.sheriff?}
  end


  def self.roles_for_players(number_of_players)
    all[0..number_of_players]
  end

  def self.all_roles
    %w{sheriff, renegade, outlaw, outlaw,
      deputy, outlaw, deputy, renegade}
  end
end

class GameOverException < Exception
end
