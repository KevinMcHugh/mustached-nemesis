module Character
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
end
