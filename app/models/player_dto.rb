class PlayerDTO
  attr_reader :name, :health, :max_health, :in_play, :hand_size, :range_increase,
    :range_decrease, :distance_to, :sheriff
  def initialize(player, for_player=nil)
    @name = player.class
    @health = player.health
    @max_health = player.max_health
    @in_play = player.in_play.map(&:class)
    @hand_size = player.hand_size
    @range_increase = player.range_increase
    @range_decrease = player.range_decrease
    @distance_to = for_player ? for_player.distance_to(player) : nil
    @sheriff = player.sheriff?
  end

  def ==(other)
    names = name == other.name
    healths = health == other.health
    max_healths = max_health == other.max_health
    in_plays = in_play == other.in_play
    hand_sizes = hand_size == other.hand_size
    range_increases = range_increase == other.range_increase
    range_decreases = range_decrease == other.range_decrease
    distance_tos = distance_to == other.distance_to
    sheriffs = sheriff == other.sheriff
    names && healths && max_healths && in_plays && hand_sizes &&
      range_increases && range_decreases && distance_tos && sheriffs
  end
  alias_method :sheriff?, :sheriff
end
