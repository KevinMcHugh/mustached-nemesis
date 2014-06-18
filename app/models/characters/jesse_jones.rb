module Character
  class JesseJonesPlayer < Player
    def draw_for_turn
      player = brain.draw_choice()
      if player && player.respond_to?(:random_from_hand)
        hand << player.random_from_hand if player.random_from_hand
        1.times { draw }
      else
        2.times { draw }
      end
    end
  end
end
