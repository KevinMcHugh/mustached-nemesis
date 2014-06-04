class Event < ActiveRecord::Base
  after_create :notify

  def notify
    game.event_listener.notify(self)
  end

  def game_over?; false; end

end
