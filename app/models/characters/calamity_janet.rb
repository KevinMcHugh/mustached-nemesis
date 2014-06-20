module Character
  class CalamityJanetPlayer < Player
    ### Allows player to send a bang as a response to being bang attacked.
    def response_is_a_playable_missed?(response_card)
      can_play?(response_card, Card.missed_card) || can_play?(response_card, Card.bang_card)
    end
    ### This assumes that if you play a missed card on your turn you mean for it to be a bang, because there is not a use case for playing misseds on your turn.
    def play_and_discard(card, target_player=nil, target_card=nil)
      PlayAndDiscard::Event.new(event_listener, self, card, target_player, target_card)
      if(card.type == Card.missed_card)
        # log("#{self.class}:#{card.class} at #{target_player.class} as a BangCard")
        actual_card = card
        card = BangCard.new(card.suit, card.number)
      else
        # log("#{self.class}:#{card.class} at #{target_player.class}")
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
