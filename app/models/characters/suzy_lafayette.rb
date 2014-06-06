module SuzyLafayetteAbility
  refine Player do
    def play_and_discard(card)
      _play_and_discard(card)
      deck.take(1) if hand_size == 0
    end
  end
end
class SuzyLafayettePlayer < Player
  using SuzyLafayetteAbility
end
