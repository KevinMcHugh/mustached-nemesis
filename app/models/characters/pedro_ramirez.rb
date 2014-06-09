class PedroRamirezPlayer < Player
  def draw_for_turn
    brain.pick(deck.most_recently_discarded, deck.top_card)
    draw
  end
end
