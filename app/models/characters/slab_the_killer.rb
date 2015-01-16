module Character
  class SlabTheKillerPlayer < Player
    def self.emoji; ':office::gun:';end
    def missed_needed(card)
      card.type == Card.bang_card ? 2 : 1
    end
  end
end
