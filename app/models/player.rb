# for each character, there should be a subclass of player
# that implements that character's
# special ability.
class Player
  include TargetOfIndians
  include TargetOfDuel
  include TargetOfBang
  include Hit
  include DynamiteCheck
  include Discard
  include PlayAndDiscard
  include Equip
  include Heal
  include Jail
  include StartTurn

  attr_accessor :hand, :event_listener
  attr_reader :in_play, :health, :brain, :role, :character, :deck, :left, :right, :max_health

  def initialize(role, deck, brain=nil)
    @deck = deck
    @hand = []
    @role = role
    @range_increase = 0
    @range_decrease = 0
    @in_play = []
    @max_health = sheriff? ? 5 : 4
    @health = max_health
    @brain = brain ? brain : Brain.new
    @bangs_played = 0
  end

  def play
    @bangs_played = 0
    dynamite
    return if dead?
    return if jail
    draw_for_turn
    start_turn

    brain.play
    while hand.size > hand_limit
     discard_choice = from_hand_dto_to_card(brain.discard)
      if hand.include?(discard_choice)
        discard(discard_choice)
      else
        x = hand.shift(hand_limit)
        hand.each { |card| @deck.discard << card }
        @hand = x
      end
    end
    @bangs_played = 0
  end

  def from_hand_dto_to_card(card_dto)
    hand.detect{|card| card.to_dto == card_dto}
  end

  def can_play?(response, type)
    response.respond_to?(:type) && response.type == type && hand.include?(response)
  end

  def beer
    beer_card = from_hand(Card.beer_card)
    if beer_card
      play_and_discard(beer_card)
    end
  end

  def beer_benefit; 1; end

  def dead?; health <= 0; end

  def right=(player)
    @right = player
  end

  def left=(player); @left= player; end

  def players
    unless @players
      @players = []
      next_player = left
      while next_player != self
        players << next_player
        next_player = next_player.left
      end
    end
    @players
  end

  def blank_players; @players = nil; end

  def from_play(card_type)
    in_play.detect { |card| card.type == card_type }
  end

  def from_hand(card_type)
    hand.detect { |card| card.type == card_type }
  end

  def in_range?(card, target_player)
    if card.no_range?
      true
    elsif card.gun_range?
      gun_range >= distance_to(target_player)
    else
      card.range >= distance_to(target_player)
    end
  end

  def gun_range
    gun = in_play.detect { |card| card.gun? }
    gun ? gun.range : 1
  end

  def range_increase
    @range_increase + in_play.select(&:range_increase?).count
  end

  def range_decrease
    @range_decrease + in_play.select(&:range_decrease?).count
  end

  def distance_to(target_player)
    left_distance = 1 + players.index(target_player)
    right_distance = players.size - players.index(target_player)
    [left_distance, right_distance].min + target_player.range_increase - self.range_decrease
  end

  def over_bang_limit?
    volcanic = from_play(Card.volcanic_card)
    volcanic ? false : @bangs_played  > 1
  end

  def discard_all
    hand.each { |card| discard(card)}
    in_play.each { |card| discard(card)}
  end

  def draw_outlaw_killing_bonus
    3.times { draw }
  end
  def play_as_beer(x,y); end
  def hand_limit; health; end
  def hand_size; hand.size; end
  def random_from_hand; @hand.sample; end
  def draw_for_turn; 2.times { draw }; end
  def draw; @hand += deck.take(1); end
  def draw!(reason=nil); deck.draw!; end

  def sheriff?; role == "sheriff"; end

  def to_s
    "#{self.class}|#{health}|#{role}|#{brain.class}"
  end
end
class OutOfRangeException < StandardError; end
class TooManyBangsPlayedException < StandardError; end
class PlayerKilledException < StandardError; end
class DuplicateCardPlayedException < StandardError;
  attr_reader :card_type
  def initialize(card_type)
    @card_type = card_type
  end
end

