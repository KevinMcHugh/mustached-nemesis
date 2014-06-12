class EventListener
  attr_reader :game, :subscribers

  def initialize(game)
    @game = game
    @subscribers = []
    @logger = Logger.new(Rails.root.join("log", "game.log"))
  end

  def subscribe(subscriber)
    subscribers << subscriber
  end

  def notify(event)
    @logger.info(event)
    subscribers.each {|sub| sub.notify(event)}
  end
end
