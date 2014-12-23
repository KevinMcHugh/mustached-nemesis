module Discard

  def discard(card, already_logged=false)
    Event.new(event_listener, self, card) unless already_logged
    deck.discard << card if card
    card_from_hand = hand.find { |c| c == card }
    card_from_play = in_play.find { |c| c == card }
    hand.delete(card_from_hand) if card_from_hand
    in_play.delete(card_from_play) if card_from_play
    if from_hand(card) || from_play(card)
      raise ArgumentError.new
    end
  end
  class Event < ::Event
    attr_reader :card
    def initialize(event_listener, player, card)
      @player = player
      @card = card
      super(event_listener)
    end

    def to_s
      "#{player.class} discarded #{card.class}"
    end
  end
end
