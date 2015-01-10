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
      if beer_card
        play_and_discard(beer_card)
        true
      else
        card_1 = brain.discard
        card_2 = brain.discard
        if from_hand_exact(card_1) && from_hand_exact(card_2)
          play_as_beer(card_1, card_2)
          true
        else
          false
        end
      end
    end

    private
    def from_hand_exact(card)
      hand.find { |c| c == card }
    end
  end
end
