module Character
  class PaulRegretPlayer < Player
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @range_increase = 1
      @max_health = sheriff? ? 4 : 3
      @health = max_health
    end
  end
end
