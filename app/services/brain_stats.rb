class BrainStats

  def execute
    brains = PlayerBrain.all
    s = brains.map do |brain|
      events = events(brain)
      stats = events.group_by(&:eventtype)
      frequency = stats.map { |stat| {eventtype: stat.first, occurences: stat.second.length, percent: 100 * stat.second.length.to_f / events.length } }
      f = frequency.sort_by { |stat| -stat[:occurences]}
      Status.new(brain, f)
    end
    flip(s)
  end

  def events(brain)
    players = PlayerRecord.where(brain: brain.to_s)
    EventRecord.where(player_record_id: players.pluck(:id))
  end

  def flip(statuses)
    header = statuses.map do |s|
      s.brain.to_s
    end
    longest_column_length = statuses.max {|s| s.stats.length}.stats.length
    rows = (0..longest_column_length -1).map do |i|

      statuses.map do |s|
        s.stats[i] || {}
      end
    end
    Table.new(header, rows)
  end

  class Status
    attr_reader :brain, :stats
    def initialize(brain, stats)
      @brain = brain
      @stats = stats
    end
  end
  class Table
    attr_reader :header, :rows
    def initialize(header, rows)
      @header = header
      @rows = rows
    end
  end
end
