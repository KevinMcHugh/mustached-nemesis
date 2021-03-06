class Event

  @@voluntary = false
  class << self
    def voluntary?; @voluntary ||= false; end
    def is_voluntary; @voluntary = true; end
  end

  attr_reader :target, :player
  def initialize(event_listener)
    event_listener.notify(self) if event_listener
  end
  def as_json(options={})
    each_instance_variable do |variable|
      if variable.is_a? Class
        variable.to_s
      else
        variable.as_json
      end
    end
  end

  def to_brainsafe
    each_instance_variable do |variable|
      convert(variable)
    end
  end

  def voluntary?; self.class.voluntary?; end
  def game_over?; false; end
  def player_killed?; false; end
  def eventtype; self.class.to_s; end
  private
  def convert(object)
    if object.is_a? Player
      PlayerDTO.new(object)
    elsif object.is_a? Card
      object.to_dto
    else
      object
    end
  end

  def each_instance_variable(&block)
    hash = {}
    hash[:@type] = self.class.to_s
    hash[:@to_s] = to_s
    instance_variables.each do |variable|
      hash[variable] = block.call(instance_variable_get(variable))
    end
    hash
  end

end
