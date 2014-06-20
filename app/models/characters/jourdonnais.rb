module Character
  class JourdonnaisPlayer < Player

    def jourdonnais_ability(card)
      if card.type == Card.bang_card
        return true if draw!(:barrel).barreled?
      end
      false
    end
  end
end
