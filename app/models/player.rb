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
    @health = 4
    @max_health = 4
    @brain = brain ? brain : Brain.new
    @logger = Logger.new(Rails.root.join("log", "game.log"))
  end

  def play
    @bangs_played = 0
    dynamite
    return if dead?
    return if jail
    draw_for_turn
    @logger.info(hand.map(&:class))
    brain.play
    while hand.size > hand_limit
      discard(brain.discard)
    end
  end

  def sheriff?
    role == "sheriff"
  end

  def hand_size
    hand.size
  end

  def target_of_indians(card, targetter)
    response = brain.target_of_indians(card, targetter)
    if response.respond_to?(:type) && response.type == Card.bang_card && hand.include?(response)
      discard(response)
    else
      hit!(targetter)
    end
  end

  def target_of_duel
    response = brain.target_of_duel(card, targetter)
    if response.respond_to?(:type) && response.type == Card.bang_card && hand.include?(response)
      discard(response)
      targetter.target_of_duel(card, self)
    else
      hit!(targetter)
    end
  end


  def target_of_bang(card, targetter)
    if from_play(Card.barrel_card)
      return false if draw!(:barrel).barreled?
    end
    response = brain.target_of_bang(card, targetter)
    if response.respond_to?(:type) && response.type == Card.missed_card && hand.include?(response) && card.missable?
      discard(response)
    else
      hit!(targetter)
    end
  end

  def hit!(hitter=nil)
    @health -= 1
    if dead?
      PlayerKilledEvent.new(event_listener, self, hitter) unless beer
    end
  end

  def beer
    beer_card = from_hand(Card.beer_card)
    if beer_card
      play_and_discard(beer_card)
      true
    else
      false
    end
  end

  def heal(regained_health=1)
    regained_health.times do
      @health += 1 if health < max_health
    end
  end

  def dead?
    health <= 0
  end

  def dynamite
    dynamite_card = from_play(Card.dynamite_card)
    if dynamite_card
      if draw!(:dynamite).explode?
        3.times { hit!  }
        discard(dynamite_card)
      else
        in_play.delete(dynamite_card)
        next_player = player.left
        while player.left.from_play(Card.dynamite_card)
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

  def beer_benefit; 1; end

  def left=(player)
    @left = player
    player.right = self unless player.right
  end

  def right=(player)
    @right = player
    player.left = self unless player.left
  end

  def from_play(card_type)
    in_play.detect { |card| card.type == card_type }
  end

  def from_hand(card_type)
    hand.detect { |card| card.type == card_type }
  end

  def discard(card)
    @logger.info("#{self.class} discarding #{card.class}")
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
    @range_decrease in_play.select(&:range_decrease?).count
  end

  def distance_to(target_player)
    left_distance = 1
    right_distance = 1
    player = self.left
    while player != target_player
      left_distance += 1
      raise ArgumentError.new if left_distance > 25
      player = player.left
    end
    player = self.right
    while player != target_player
      right_distance += 1
      raise ArgumentError.new if right_distance > 25
      player = player.right
    end
    [left_distance, right_distance].min + target_player.range_increase - self.range_decrease
  end

  def play_and_discard(card, target_player=nil, target_card=nil)
    @logger.info("#{self.class}:#{card.class} at #{target_player.class}")
    if card.type == Card.bang_card
      @bangs_played +=1
    end
    raise TooManyBangsPlayedException.new if @bangs_played > bang_limit
    if in_range?(card, target_player)
      discard(card)
      card.play(self, target_player, target_card)
    else
      raise OutOfRangeException.new
    end
  end

  def hand_limit
    health
  end

  def draw_for_turn
    2.times { draw }
  end

  def draw
    @hand += deck.take(1)
  end

  def draw!(reason=nil)
    deck.draw!
  end

  def to_s
    "#{self.class} #{health} #{role}"
  end

  def discard_all
    hand.each { |card| discard(card)}
    in_play.each { |card| discard(card)}
  end

  def bang_limit; 1; end
end
class OutOfRangeException < StandardError; end
class TooManyBangsPlayedException < StandardError; end

class PlayerKilledEvent < Event
  attr_reader :killed, :killer
  def initialize(event_listener, killed, killer)
    @killed = killed
    @killer = killer
    @killed.discard_all
    @killed.left.right = @killed.right
    @killed.right.left = @killed.left

    if @killed.role == 'outlaw'
      3.times { @killer.draw }
    elsif @killer.sheriff? && @killed.role == 'deputy'
      @killer.discard_all
    end

    super(event_listener)
  end
  def to_s
    "#{killed} has been killed by #{killer}"
  end
  def player_killed?; true; end
end
