class EventListener
  attr_reader :game, :subscribers

  def initialize(game)
    @game = game
  end

  def subscribe(subscriber)
    subscribers << subscriber
  end

  def notify(event)
    subscribers.each {|sub| sub.notify(event)}
  end
end
