class BrainStats

  def initialize(brain)
    @brain = brain
  end

  def execute
    players = player_records
    events = EventRecord.where(player_record_id: players.pluck(:id))
    binding.pry
  end

  def player_records
    PlayerRecord.where(brain: @brain.to_s)
  end
end