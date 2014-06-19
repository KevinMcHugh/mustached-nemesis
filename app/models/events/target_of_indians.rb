module TargetOfIndians

  def target_of_indians(card, targetter)
    Event.new(event_listener, self, card, targetter)
  end

  class Event < ::Event

    attr_reader :target, :targetter
    def initialize(event_listener, target, card, targetter)
      @target = target
      @targetter = targetter
      response = target.from_hand_dto_to_card(target.brain.target_of_indians(card, targetter))
      if target.can_play?(response, Card.bang_card)
        target.discard(response)
      else
        target.hit!(targetter)
      end
      super(event_listener)
    end
    def to_s
      "#{targetter.class} played Indians at #{target.class}"
    end
  end
end
