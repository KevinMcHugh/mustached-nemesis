module Character
  class PedroRamirezPlayer < Player
    def draw_for_turn
      card = brain.draw_choice(deck.most_recently_discarded)
      if card && card == deck.most_recently_discarded
        hand << card
        1.times { draw }
      else
        2.times { draw }
      end
    end
  end
end
