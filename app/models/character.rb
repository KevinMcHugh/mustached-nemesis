module Character
  Dir[Rails.root.join("app","models","characters","*.rb")].each {|file| require file }
  def self.all(random)
    @@characters ||= Character.constants.select { |c| Character.const_get(c).is_a?(Class) }
    clone = @@characters.clone
    clone.sort!.shuffle!(random: random)
  end
  class KitCarlsonPlayer < Player
    def self.emoji; ':three::flower_playing_cards::arrow_right::two::flower_playing_cards:';end
    def draw_for_turn
      cards = deck.take(3)
      response = brain.pick(2, cards)
      raise StandardError.new unless response.length == 2
      # TODO: does this use CardDTOs?
      @hand += response
      (cards - response).each do |card|
        deck.draw.push(card)
      end
    end
  rescue
  end
  class JesseJonesPlayer < Player
    def self.emoji; ':skull::flower_playing_cards:';end
    def draw_for_turn
      players_with_cards = players.reject { |p| p.hand.empty? }
      player = brain.draw_choice([nil] + players_with_cards)
      if player
        target = player.random_from_hand
        hand << target
        1.times { draw }
      else
        2.times { draw }
      end
    end
  end
  class WillyTheKidPlayer < Player
    def self.emoji; ':baby::man:'; end
    def over_bang_limit?; false; end
  end
  class BartCassidyPlayer < Player
    def self.emoji; ':boom::arrow_down:';end
    def hit!(hitter=nil)
      super(hitter)
      draw unless dead?
    end
  end
  class BlackJackPlayer < Player
    def self.emoji; ':arrow_down::hearts::diamonds::question::arrow_down:';end
    def draw_for_turn
      draw
      card = draw.first
      CardRevealedEvent.new(event_listener, card, self)
      draw if card.red?
    end
  end
  class CalamityJanetPlayer < Player
    def self.emoji; ':dash::woman:';end
    ### Allows player to send a bang as a response to being bang attacked.
    def response_is_a_playable_missed?(response_card)
      can_play?(response_card, Card.missed_card) || can_play?(response_card, Card.bang_card)
    end

    def counts_as_bang?(card)
      [Card.bang_card, Card.missed_card].include?(card.type)
    end

    ### This assumes that if you play a missed card on your turn you mean for it to be a bang
    ### because there is not a use case for playing misseds on your turn.
    def play_card(card, target_player, target_card)
      if card.type == Card.missed_card
        card = BangCard.new(card.suit, card.number)
      end
      super(card, target_player, target_card)
    end
  end
  class ElGringoPlayer < Player
    def self.emoji; ':cactus::us:';end
    def initialize(role, deck, brain)
      super(role, deck, brain)
      @max_health = sheriff? ? 4 : 3
      @health = max_health
    end
    def hit!(hitter=nil)
      super(hitter)
      if hitter
        card = hitter.random_from_hand
        hitter.hand.delete(card)
        hand << card if card
      end
    end
  end
  class JourdonnaisPlayer < Player
    def self.emoji; ':package::man:';end
    def jourdonnais_ability(card)
      if card.type == Card.bang_card
        return true if draw!(:barrel).barreled?
      end
      false
    end
  end
  # TODO: This assumes you always want to get out of jail, not be shot
  # and not be dynamited. This is almost always true.
  # Imagine you're the deputy, you have 4 health, and
  # the sheriff has 1. You're dynamited and have the
  # option to take the explosion.
  class LuckyDukePlayer < Player
    def self.emoji; ':bangbang::man:';end
    def draw!(reason)
      options = 2.times.map { deck.draw! }
      if [:jail, :dynamite].include?(reason)
        card = options.find { |option| !option.send(reasons_to_methods[reason]) }
      elsif reason == :barrel
        card = options.find { |option| option.barreled? }
      end
      card ? card : options.first
    end

    private
    def reasons_to_methods
      { jail: :still_in_jail?, dynamite: :explode? }
    end
  end
  class PaulRegretPlayer < Player
    def self.emoji; ':racehorse::man:';end
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @max_health = sheriff? ? 4 : 3
      @health = max_health
    end

    def range_increase
      1 + super
    end
  end
  class PedroRamirezPlayer < Player
    def self.emoji; ':fast_forward::arrow_down:';end
    def draw_for_turn
      discard = deck.most_recently_discarded
      card = brain.draw_choice([nil, discard]) if discard
      if card && card == discard
        hand << card
        1.times { draw }
      else
        2.times { draw }
      end
    end
  end
  class RoseDoolanPlayer < Player
    def self.emoji; ':rose::telescope:';end
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @range_decrease = 1
    end
  end
  class SidKetchumPlayer < Player
    def self.emoji; ':fast_forward::fast_forward::hospital:';end
    def play_as_beer(card_1, card_2)
      if hand.include?(card_1) && hand.include?(card_2)
        discard(card_1)
        discard(card_2)
        heal
      end
    end
    def beer
      beer_card = from_hand(Card.beer_card)
      if beer_card
        play_and_discard(beer_card)
        true
      else
        card_1 = brain.discard
        card_2 = brain.discard
        if from_hand_exact(card_1) && from_hand_exact(card_2)
          play_as_beer(card_1, card_2)
          true
        else
          false
        end
      end
    end

    private
    def from_hand_exact(card)
      hand.find { |c| c == card }
    end
  end
  class SlabTheKillerPlayer < Player
    def self.emoji; ':office::gun:';end
    def missed_needed(card)
      card.type == Card.bang_card ? 2 : 1
    end
  end
  class SuzyLafayettePlayer < Player
    def self.emoji; ':zero::flower_playing_cards::arrow_down:'; end
    def play_and_discard(card, target_player=nil, target_card=nil)
      super(card, target_player, target_card)
      draw if hand_size == 0
    end
  end
  class VultureSamPlayer < Player
    # Whenever a character is eliminated from the game,
    # Sam takes all the cards that player had in his hand and in play, and adds them to his hand.
    #Code is in the PlayerKilledEvent
    def self.emoji; ':bird::man:'; end
  end
end