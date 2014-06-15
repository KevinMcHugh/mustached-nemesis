module Character
  class BlackJackPlayer < Player
    def draw_for_turn
      draw
      card = draw.first
      CardRevealedEvent.new(event_listener, card, self)
      draw if card.red?
    end
  end
end
