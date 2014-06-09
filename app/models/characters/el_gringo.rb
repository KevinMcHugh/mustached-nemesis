module ElGringoAbility
  refine Player do
    def hit!(hitter=nil)
      _hit!(hitter)
      hitter.hand.sample if hitter
    end
  end
end
class ElGringoPlayer < Player
  using ElGringoAbility
end
