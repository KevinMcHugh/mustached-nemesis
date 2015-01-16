module Character
  class SuzyLafayettePlayer < Player
    def self.emoji; ':woman::city_sunrise:'; end
    def play_and_discard(card, target_player=nil, target_card=nil)
      super(card, target_player, target_card)
      draw if hand_size == 0
    end
  end
end
