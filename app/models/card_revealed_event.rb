class CardRevealedEvent < Event
  attr_reader :card, :player
  def initialize(event_listener, card, player=nil)
    @card = card
    @player = player
    super(event_listener)
  end

  def to_s
    "#{card} revealed by #{player}"
  end
end
