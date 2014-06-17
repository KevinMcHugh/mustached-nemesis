module Character
  class SidKetchumPlayer < Player
    def play_as_beer(card_1, card_2)
      if hand.include?(card_1) && hand.include?(card_2)
        discard(card_1)
        discard(card_2)
        heal
      end
    end
    def beer
      beer_card = from_hand(Card.beer_card)
      # TODO doesn't work with 2 players remaining
      if beer_card
        play_and_discard(beer_card)
        true
      else
        card_1 = brain.discard
        card_2 = brain.discard
        if from_hand(card_1) && from_hand(card_2)
          play_as_beer(card_1, card_2)
          true
        else
          false
        end
      end
    end
  end
end
