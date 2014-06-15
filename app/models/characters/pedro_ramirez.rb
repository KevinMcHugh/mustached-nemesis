## This is not quite right.  PedroRamirez has to choose the top card without looking at it.  I'm not sure the best way to handle that
module Character
  class PedroRamirezPlayer < Player
    def draw_for_turn
      brain.pick(1, deck.most_recently_discarded, deck.top_card)
      draw
    end
  end
end
