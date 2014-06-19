module TargetOfBang

  def target_of_bang(card, targetter)
    missed_needed = 1
    missed_count = 0
    if card.type == Card.bang_card && targetter.class.to_s == 'Character::SlabTheKillerPlayer'
      missed_needed = 2
    end
    if from_play(Card.barrel_card)
      missed_count += 1 if draw!(:barrel).barreled?
      return false if missed_needed <= missed_count
    end
    response = brain.target_of_bang(card, targetter, missed_needed)
    if response
      response.each do |response_card|
        response_card = from_hand_dto_to_card(response_card)

        if can_play?(response_card, Card.missed_card) && card.missable?
          discard(response_card)
          missed_count += 1
          return false if missed_needed <= missed_count
        end
      end
    end
    hit!(targetter)
  end

  class Event < ::Event
    attr_reader :target, :targetter
    def initialize(event_listener, target, targetter)
      @target = target
      @targetter = targetter
      super(event_listener)
    end
    def to_s
      "#{targetter.class} played bang at #{target.class}"
    end
  end
end
