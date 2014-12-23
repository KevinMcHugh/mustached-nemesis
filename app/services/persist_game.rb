class PersistGame

  def initialize(params)
    @game = params[:game]
    @brains = params[:brains]
    @expansions = params[:expansions]
    @seed = params[:seed]
    @brains_to_players = params[:brains_to_players]
  end

  def execute
    gr = GameRecord.create(seed: @seed, rounds: @game.round)
    persist_players(gr)
    persist_events(gr)
    persist_expansions(gr)
  end

  private
  def persist_events(gr)
    @game.events.each_with_index do |event, index|
      EventRecord.create(game_record_id: gr.id, order: index, player_record_id: 0, target_player_record_id: 0,
       event_json: event.to_json)
    end
  end

  def persist_players(gr)
    @brains.each_with_index do |brain, index|
      won = @game.winners.map(&:class).map(&:to_s).include?(brain.player.character)
      PlayerRecord.create(game_record_id: gr.id, order: index, brain: brain.class.to_s,
        role: brain.role, won: won, character: brain.player.character)
    end
  end

  def persist_expansions(gr)
    @expansions.each do |expansion|
      Expansion.create(game_record_id: gr.id, name: expansion)
    end
  end
end
