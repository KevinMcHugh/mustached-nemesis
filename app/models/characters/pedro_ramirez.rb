module Character
  class PedroRamirezPlayer < Player
    def draw_for_turn
      brain.pick(1, deck.most_recently_discarded, deck.top_card)
      draw
    end
  end
end
