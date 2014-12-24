class BrainStats

  def initialize(brain)
    @brain = brain
  end

  def execute
    players = player_records
    events = EventRecord.where(player_record_id: players.pluck(:id))
    stats = events.group_by(&:eventtype)
    frequency = stats.map { |stat| {eventtype: stat.first, occurences: stat.second.length, percent: 100 * stat.second.length.to_f / events.length } }
    frequency.sort_by { |stat| -stat[:occurences]}
    # binding.pry
  end

  def player_records
    PlayerRecord.where(brain: @brain.to_s)
  end
end