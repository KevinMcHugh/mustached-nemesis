class GameOverEvent < Event
  attr_reader :player_killed_event, :game, :winners
  def initialize(event_listener, player_killed_event, game)
    @player_killed_event = player_killed_event
    @game = game
    winner
    super(event_listener)
  end

  def winner
    living_players = game.living_players
    @winners = []
    if living_players.find { |p| p.sheriff?}
      @winners = game.players.find_all { |player| ['deputy', 'sheriff'].include?(player.role)}.uniq
      'the forces of law have'
    elsif living_players.map(&:role) == ['renegade']
      @winners = living_players
      'the renegade has'
    else
      @winners = game.players.find_all { |player| player.role == 'outlaw'}.uniq
      'the outlaws have'
    end
  end

  def to_s
    "#{winner} prevailed in #{game.round} rounds!\n The following people are still alive: #{game.living_players.map(&:to_s)}"
  end

  def as_json(options={})
    {:@type => self.class.to_s, winners: @winners.map(&:as_json)}
  end
  def game_over?; true; end
end
