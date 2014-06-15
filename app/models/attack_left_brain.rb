
## All Brains must be put in the PlayerBrain module to allow them to be picked up by the game initalizer
module PlayerBrain
  ## This is a sample brain to show basic brain structure and interaction with the player.
  class AttackLeftBrain < Brain

    #The brain is instantiated with it's role.  So that it can be used later in the game
    def initialize(role)
      @role = role
    end

    # you have the option of picking from many cards, pick the best one.
    def pick(number, *cards)
      cards.flatten.first(number)
    end

    #After instantiation the Game will pass the brain two characters from the characters in the models/characters folder, the choose_character method must return one of the two characters.
    def choose_character(character_1, character_2)
      character_1
    end

    #This method is called on your brain when you are the target of a card that has a bang action (a missable attack). Your brain is given the card that attacked them.  The method should return a card from your hand
    def target_of_bang(card, targetter, missed_needed)
      if player.hand.count{ |x| x.type == Card.missed_card } >= missed_needed
        player.hand.select{|x| x.type == Card.missed_card}.first(missed_needed)
      else
        []
      end
    end
    def target_of_indians(card, targetter)
      player.from_hand(Card.bang_card)
    end
    def target_of_duel(card, targetter)
      player.from_hand(Card.bang_card)
    end
    #This method is called if your hand is over the hand limit, it returns the card that you would like to discard.
    # Returning nil or a card you don't have is a very bad idea. Bad things will happen to you.
    def discard
      player.hand.first
    end

    #This is the method that is called on your turn.
    def play
      bang = player.from_hand(Card.bang_card)
      if bang
        left_player = player.players.first
        if left_player.distance_to <= 1
          player.play_card(bang, left_player)
        end
      end
    end

    private
    attr_reader :role
  end
end
