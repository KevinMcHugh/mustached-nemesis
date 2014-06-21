class Event
  def initialize(event_listener)
    event_listener.notify(self) if event_listener
  end
  def as_json(options={})
    hash = {}
    hash[:@type] = self.class.to_s

    instance_variables.each do |variable|
      hash[variable] = instance_variable_get(variable).as_json
    end
    hash
  end
  def game_over?; false; end
  def player_killed?; false; end
end
