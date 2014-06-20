module Jail

  def jail
    jail_card = from_play(Card.jail_card)
    still_in_jail = false
    if jail_card
      still_in_jail = draw!(:jail).still_in_jail?
      Event.new(event_listener, self, still_in_jail)
      discard(jail_card)
    end
    still_in_jail
  end

  class Event < ::Event
    attr_reader :player, :still_in_jail
    def initialize(event_listener, player, still_in_jail)
      @player = player
      @still_in_jail = still_in_jail
      super(event_listener)
    end

    def to_s
      still_in_jail ? "#{player.class}'s jail sentence has been extended." : "#{player.class} was released from jail!"
    end
  end
end
