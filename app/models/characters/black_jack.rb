module Character
  class BlackJackPlayer < Player
    def self.emoji; ':black_large_square::jack_o_lantern:';end
    def draw_for_turn
      draw
      card = draw.first
      CardRevealedEvent.new(event_listener, card, self)
      draw if card.red?
    end
  end
end
