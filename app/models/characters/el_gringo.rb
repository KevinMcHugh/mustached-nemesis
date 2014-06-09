class ElGringoPlayer < Player
  def hit!(hitter=nil)
    super(hitter)
    hitter.hand.sample if hitter
  end
end
