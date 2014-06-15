module Character
  class BartCassidyPlayer < Player
    def hit!(hitter=nil)
      super(hitter)
      draw
    end
  end
end
