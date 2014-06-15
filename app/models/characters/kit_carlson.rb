module Character
  class KitCarlsonPlayer < Player
    def draw_for_turn
      cards = deck.take(3)
      response = brain.pick(2, cards)
      raise StandardError.new unless response.length == 2
      @hand += response
      (cards - response).each do |card|
        deck.discard.push(card)
      end
    end
  rescue
  end
end
