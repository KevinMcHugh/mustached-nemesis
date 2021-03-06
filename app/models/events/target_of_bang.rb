module TargetOfBang

  def target_of_bang(card, targetter)
    Event.new(event_listener, self, targetter)
    missed_count = 0
    missed_needed = targetter.missed_needed(card)

    missed_count += 1 if jourdonnais_ability(card)

    return false if missed_needed <= missed_count
    if from_play(Card.barrel_card)
      missed_count += 1 if draw!(:barrel).barreled?
      return false if missed_needed <= missed_count
    end
    response = brain.target_of_bang(card, targetter, missed_needed)
    if response
      response.each do |response_card|
        response_card = from_hand_dto_to_card(response_card)

        if response_is_a_playable_missed?(response_card) && card.missable?
          discard(response_card)
          missed_count += 1
          return false if missed_needed <= missed_count
        end
      end
    end
    hit!(targetter)
  end

  def response_is_a_playable_missed?(response_card)
    can_play?(response_card, Card.missed_card)
  end

  def missed_needed(card); 1; end


  def jourdonnais_ability(card); false; end

  class Event < ::Event
    def initialize(event_listener, target, targetter)
      @target = target
      @player = targetter
      super(event_listener)
    end
    def to_s
      "#{player.class} played bang at #{target.class}"
    end
  end
end
