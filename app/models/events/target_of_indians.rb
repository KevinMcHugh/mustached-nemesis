module TargetOfIndians

  def target_of_indians(card, targetter)
    response = from_hand_dto_to_card(brain.target_of_indians(card, targetter))
    Event.new(event_listener, self, targetter)
    if can_play?(response, Card.bang_card)
      discard(response)
    else
      hit!(targetter)
    end
  end

  class Event < ::Event
    attr_reader :target, :targetter
    def initialize(event_listener, target, targetter)
      @target = target
      @targetter = targetter
      super(event_listener)
    end
    def to_s
      "#{targetter.class} played Indians at #{target.class}"
    end
  end
end