module Character
  class RoseDoolanPlayer < Player
    def self.emoji; ':rose::woman:';end
    def initialize(role, deck, brain=nil)
      super(role, deck, brain)
      @range_decrease = 1
    end
  end
end
