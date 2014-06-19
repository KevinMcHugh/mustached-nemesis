module Character
  class CalamityJanetPlayer < Player
    ### Allows player to send a bang as a response to being bang attacked.
    def target_of_bang(card, targetter)
      missed_needed = 1
      missed_count = 0
      if card.type == Card.bang_card && targetter.class.to_s == 'SlabTheKillerPlayer'
        missed_needed = 2
      end
      if from_play(Card.barrel_card)
        missed_count += 1 if draw!(:barrel).barreled?
        return false if missed_needed <= missed_count
      end
      response = brain.target_of_bang(card, targetter, missed_needed)
      response.each do |response_card|
        response_card = from_hand_dto_to_card(response_card)
        if (can_play?(response_card, Card.missed_card) || can_play?(response_card, Card.bang_card)) && card.missable?
          discard(response_card)
          missed_count += 1
          return false if missed_needed <= missed_count
        end
      end
      hit!(targetter)
    end
    ### This assumes that if you play a missed card on your turn you mean for it to be a bang, because there is not a use case for playing misseds on your turn.
    def play_and_discard(card, target_player=nil, target_card=nil)
      if(card.type == Card.missed_card)
        log("#{self.class}:#{card.class} at #{target_player.class} as a BangCard")
        actual_card = card
        card = BangCard.new(card.suit, card.number)
      else
        log("#{self.class}:#{card.class} at #{target_player.class}")
        actual_card = card
      end
      if card.type == Card.bang_card
        @bangs_played +=1
      end
      raise TooManyBangsPlayedException.new if over_bang_limit?
      if in_range?(card, target_player)
        discard(actual_card)
        card.play(self, target_player, target_card)
      else
        raise OutOfRangeException.new
      end
    end
  end
end
