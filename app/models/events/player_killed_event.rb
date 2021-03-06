class PlayerKilledEvent < Event
  attr_reader :killed, :killer
  def initialize(event_listener, killed, killer)
    @killed = killed
    @killer = killer
    @target = killed

    @killed.players.map(&:blank_players!)
    @killed.left.right = @killed.right
    @killed.right.left = @killed.left
    super(event_listener)

    # Vulture Sam takes dead players cards See Character::VultureSamPlayer
    # TODO: I hate this initializer and I hate this hack
    vs = @killed.players.detect {|p| p.class.to_s == "Character::VultureSamPlayer"}
    if vs
      @killed.hand.each { |card| vs.hand << card }
      @killed.in_play.each { |card| vs.hand << card }
      @killed.hand.clear
      @killed.in_play.clear
    else
      @killed.discard_all
    end

    if @killed.role == 'outlaw'
      @killer.draw_outlaw_killing_bonus if @killer
    elsif @killer && @killer.sheriff? && @killed.role == 'deputy'
      @killer.discard_all
    end
  end

  def to_s
    killer_string = killer || DynamiteCard.killer
    "#{killed} has been killed by #{killer_string}"
  end

  def sheriff_killed?
    killed.sheriff?
  end
  def player_killed?; true; end
end
