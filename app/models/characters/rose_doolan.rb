module Character
  class RoseDoolanPlayer < Player
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @range_decrease = 1
    end
  end
end
