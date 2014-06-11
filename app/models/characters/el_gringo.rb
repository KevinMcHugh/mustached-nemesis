class ElGringoPlayer < Player
  def initialize(role, deck)
    super(role, deck)
    @max_health = 3
    @health = 3
  end
  def hit!(hitter=nil)
    super(hitter)
    hitter.hand.sample if hitter
  end
end
