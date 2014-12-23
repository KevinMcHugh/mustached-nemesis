module TargetOfDuel

  def target_of_duel(card, targetter)
    Event.new(event_listener, self, targetter)
    response = from_hand_dto_to_card(brain.target_of_duel(card, targetter))
    if can_play?(response, Card.bang_card)
      discard(response)
      targetter.target_of_duel(card, self)
    else
      hit!(targetter)
    end
  end

  class Event < ::Event
    def initialize(event_listener, target, targetter)
      @target = target
      @player = targetter
      super(event_listener)
    end
    def to_s
      "#{player.class} played duel at #{target.class}"
    end
  end
end
