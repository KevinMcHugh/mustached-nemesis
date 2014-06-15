module Character
  class JourdonnaisPlayer < Player
    def target_of_bang(card, targetter)
      if card.type == Card.bang_card
        return false if draw!(:barrel).barreled?
      end
      super(card, targetter)
    end
  end
end
