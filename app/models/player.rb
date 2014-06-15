require 'card'

# for each character, there should be a subclass of player
# that uses a refinement implementing that character's
# special ability. You have to create that subclass because
# `using` cannot be called from within a method. Blech.
#
# For `method`,  where `method` is subject to being overriden
# by a refinement, `method` should internally call `_method`,
# so that the refinement can use the original behavior without
# changing the API.

class Player
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
    log(hand.map(&:class))
    brain.play
    while hand.size > hand_limit
      discard_choice = brain.discard
      if hand.include?(discard_choice)
        discard(discard_choice)
      else
        x = hand.shift(hand_limit)
        @deck.discard += hand
        @hand = x

      end
    end
  end

  def target_of_indians(card, targetter)
    response = brain.target_of_indians(card, targetter)
    if can_play?(response, Card.bang_card)
      discard(response)
    else
      hit!(targetter)
    end
  end

  def target_of_duel(card, targetter)
    response = brain.target_of_duel(card, targetter)
    if can_play?(response, Card.bang_card)
      discard(response)
      targetter.target_of_duel(card, self)
    else
      hit!(targetter)
    end
  end

  def target_of_bang(card, targetter)
    missed_needed = 1
    missed_count = 0
    if card.type == Card.bang_card && targetter.class.to_s == 'SlabTheKillerPlayer'
      missed_needed = 2
    end
    if from_play(Card.barrel_card)
      missed_count += 1 if draw!(:barrel).barreled?
      return false if missed_needed <= missed_count
    end
    response = brain.target_of_bang(card, targetter, missed_needed)
    response.each do |response_card|
      if can_play?(response_card, Card.missed_card) && card.missable?
        discard(response_card)
        missed_count += 1
        return false if missed_needed <= missed_count
      end
    end
    hit!(targetter)
  end

  def can_play?(response, type)
    response.respond_to?(:type) && response.type == type && hand.include?(response)
  end

  def hit!(hitter=nil)
    @health -= 1 if @health > 0
    if dead?
      PlayerKilledEvent.new(event_listener, self, hitter) unless beer
    end
  end

  def beer
    beer_card = from_hand(Card.beer_card)
    # TODO doesn't work with 2 players remaining
    if beer_card
      play_and_discard(beer_card)
      true
    else
      false
    end
  end

  def beer_benefit; 1; end

  def heal(regained_health=1)
    regained_health.times { @health += 1 if health < max_health }
  end
  def dead?; health <= 0; end

  def dynamite
    dynamite_card = from_play(Card.dynamite_card)
    if dynamite_card
      if draw!(:dynamite).explode?
        3.times { hit!  }
        discard(dynamite_card)
      else
        in_play.delete(dynamite_card)
        next_player = left
        while next_player.left.from_play(Card.dynamite_card)
          next_player = next_player.left
        end
        next_player.in_play << dynamite_card
      end
    end
  end

  def jail
    jail_card = from_play(Card.jail_card)
    if jail_card
      discard(jail_card)
      return true if draw!(:jail).still_in_jail?
    end
    false
  end

  def right=(player)
    @right = player
    player.left = self
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

  def discard(card)
    log("#{self.class} discarding #{card.class}")
    deck.discard << card
    in_play.delete(card)
    hand.delete(card)
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

  def play_and_discard(card, target_player=nil, target_card=nil)
    log("#{self.class}:#{card.class} at #{target_player.class}")
    if card.type == Card.bang_card
      @bangs_played +=1
    end
    raise TooManyBangsPlayedException.new if over_bang_limit?
    if in_range?(card, target_player)
      discard(card)
      card.play(self, target_player, target_card)
    else
      raise OutOfRangeException.new
    end
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
    log("#{self.class} just killed an outlaw! YEEE-HAW!")
  end

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
  def logger=(logger); @logger = logger; end
  def log(message)
    @logger.info(message) if @logger
  end
end
class OutOfRangeException < StandardError; end
class TooManyBangsPlayedException < StandardError; end

class PlayerKilledEvent < Event
  attr_reader :killed, :killer
  def initialize(event_listener, killed, killer)
    @killed = killed
    @killer = killer
    @killed.discard_all
    @killed.players.map(&:blank_players)
    @killed.left.right = @killed.right

    if @killed.role == 'outlaw'
      @killer.draw_outlaw_killing_bonus if @killer
    elsif @killer && @killer.sheriff? && @killed.role == 'deputy'
      @killer.discard_all
    end

    super(event_listener)
  end
  def to_s
    killer_string = killer || 'DYNAMITE, CATS AND KITTENS'
    "#{killed} has been killed by #{killer_string}"
  end
  def player_killed?; true; end
end
