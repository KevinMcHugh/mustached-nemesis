module PedroRamirezAbility
  refine Player do
    def draw_for_turn
      brain.pick(deck.most_recently_discarded, deck.top_card)
      draw
    end

  end
end
class PedroRamirezPlayer < Player
  using PedroRamirezAbility
end
