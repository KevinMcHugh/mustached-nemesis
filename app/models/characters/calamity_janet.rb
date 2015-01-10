module Character
  class CalamityJanetPlayer < Player
    ### Allows player to send a bang as a response to being bang attacked.
    def response_is_a_playable_missed?(response_card)
      can_play?(response_card, Card.missed_card) || can_play?(response_card, Card.bang_card)
    end

    def counts_as_bang?(card)
      [Card.bang_card, Card.missed_card].include?(card.type)
    end

    ### This assumes that if you play a missed card on your turn you mean for it to be a bang
    ### because there is not a use case for playing misseds on your turn.
    def play_card(card, target_player, target_card)
      if card.type == Card.missed_card
        card = BangCard.new(card.suit, card.number)
      end
      super(card, target_player, target_card)
    end
  end
end
