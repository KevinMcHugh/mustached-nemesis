class Character
  def self.suzy_lafayette
    self.new('suzy_lafayette', 4)
  end

  attr_reader :name, :max_health
  def initialize(name, max_health)
    @name = name
    @max_health = max_health
  end
end
