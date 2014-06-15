module Character
  class PaulRegretPlayer < Player
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @range_increase = 1
    end
  end
end
