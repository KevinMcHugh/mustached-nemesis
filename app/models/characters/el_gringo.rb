module Character
  class ElGringoPlayer < Player
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
end
