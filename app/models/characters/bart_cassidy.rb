module Character
  class BartCassidyPlayer < Player
    def hit!(hitter=nil)
      super(hitter)
      draw unless dead?
    end
  end
end
