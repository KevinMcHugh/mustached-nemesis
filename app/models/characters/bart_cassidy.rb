module Character
  class BartCassidyPlayer < Player
    def self.emoji; ':snowboarder:';end
    def hit!(hitter=nil)
      super(hitter)
      draw unless dead?
    end
  end
end
