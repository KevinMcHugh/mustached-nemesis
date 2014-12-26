class BrainStats

  def execute
    brains = PlayerBrain.all
    statuses = brains.map(&:to_s).flat_map do |brain|
      events = events(brain)
      events_by_type = events.group_by(&:eventtype)
      stats_for(events_by_type, brain)
    end.compact
    statuses = statuses.sort_by { |status| status.brain }
    eventtypes_to_stats = statuses.group_by(&:eventtype)
    eventtypes_to_stats.map do |eventtype_to_stats|
      tablify(eventtype_to_stats)
    end
  end

  def events(brain)
    players = PlayerRecord.where(brain: brain)
    EventRecord.where(player_record_id: players.pluck(:id), voluntary: true)
  end

  def tablify(eventtype_to_stats)
    stats = eventtype_to_stats.second

    header = stats.map { |s| s.brain }
    longest_column_length = stats.max {|stat| stat.counts.length}.counts.length

    rows = (0..longest_column_length - 1).map do |i|
      stats.map do |s|
        s.counts.to_a[i] || []
      end
    end
    Table.new(eventtype_to_stats.first, header, rows)
  end

  def stats_for(events_by_type, brain)
    events_by_type.map do |event|
      eventtype = event.first
      next if eventtype == 'TapBadge::Event'
      events = event.second
      cardtypes = events.map do |e|
        JSON.parse(e.event_json)['@card']['@type']
      end
      counts = CountOccurences.new(cardtypes).execute
      Status.new(brain, eventtype, counts)
    end
  end

  class Status
    attr_reader :brain, :eventtype, :counts
    def initialize(brain, eventtype, counts)
      @brain = brain
      @eventtype = eventtype
      @counts = counts.sort_by { |k, v| -v }
    end
  end
  class Table
    attr_reader :title, :header, :rows
    def initialize(title, header, rows)
      @title = title
      @header = header
      @rows = rows
    end
  end
end
