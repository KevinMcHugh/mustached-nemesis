module Character
  class ElGringoPlayer < Player
    def initialize(role, deck, brain)
      super(role, deck, brain)
      @max_health = sheriff? ? 4 : 3
      @health = max_health
    end
    def hit!(hitter=nil)
      super(hitter)
      hitter.hand.sample if hitter
    end
  end
end
