class GameOverEvent < Event
  attr_reader :game
  def initialize(event_listener, game)
    @game = game
    super(event_listener)
  end

  def winners
    return @winners if @winners
    living_players = game.living_players
    if living_players.find { |p| p.sheriff?}
      @winners = game.players.find_all { |player| ['deputy', 'sheriff'].include?(player.role)}.uniq
    elsif living_players.map(&:role) == ['renegade']
      @winners = living_players
    else
      @winners = game.players.find_all { |player| player.role == 'outlaw'}.uniq
    end
    @winners
  end

  def to_s
    "#{string_for_winner} prevailed in #{game.round} rounds!"
  end

  def as_json(options={})
    {:@type => self.class.to_s, winners: @winners.map(&:as_json)}
  end
  def game_over?; true; end

  def string_for_winner
    @@strings ||= {['sheriff','deputy'] => 'the forces of law have',
      ['renegade'] => 'the renegade has',
      ['outlaw'] => 'the outlaws have'
    }
    @@strings[winners.map(&:role).uniq]
  end
end
