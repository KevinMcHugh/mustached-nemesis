## All Brains must be put in the PlayerBrain module to allow them to be picked up by the game initalizer
module PlayerBrain
  ## This is a sample brain to show basic brain structure and interaction with the player.
  class AttackLeftBrain < Brain

    #The brain is instantiated with it's role.  So that it can be used later in the game
    def initialize(role)
      @role = role
    end
    #After instantiation the Game will pass the brain two characters from the characters in the models/characters folder, the choose_character method must return one of the two characters.
    def choose_character(character_1, character_2)
      character_1
    end

    #This method is called on your brain when you are the target of a card that has a bang action (a missable attack). Your brain is given the card that attacked them.  The method should return a card from your hand
    def target_of_bang(card)
      player.hand.detect{ |x| x == Card.missed_card }
    end

    #This method is called if your hand is over the hand limit, it returns the card that you would like to discard.
    def discard
      player.hand.first
    end

    #This is the method that is called on your turn.
    def play
      begin
        bang = player.hand.detect {|x| x == Card.bang_card}
        while bang
          player.play_and_discard(bang, player.left)
          bang = player.hand.detect {|x| x == Card.bang_card}
        end
      rescue e
      end
    end

    private
    attr_reader :role
  end
end