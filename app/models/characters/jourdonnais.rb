module Character
  class JourdonnaisPlayer < Player
    def target_of_bang(card, targetter)
      missed_needed = 1
      missed_count = 0
      if card.type == Card.bang_card && targetter.class.to_s == 'SlabTheKillerPlayer'
        missed_needed = 2
      end
      if card.type == Card.bang_card
        missed_count += 1 if draw!(:barrel).barreled?
        return false if missed_needed <= missed_count
      end

      if from_play(Card.barrel_card)
        missed_count += 1 if draw!(:barrel).barreled?
        return false if missed_needed <= missed_count
      end
      response = brain.target_of_bang(card, targetter, missed_needed)
      response.each do |response_card|
        if can_play?(response_card, Card.missed_card) && card.missable?
          discard(response_card)
          missed_count += 1
          return false if missed_needed <= missed_count
        end
      end
      hit!(targetter)
    end
  end
end
