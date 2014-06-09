class SuzyLafayettePlayer < Player
  def play_and_discard(card)
    super(card)
    deck.take(1) if hand_size == 0
  end
end
