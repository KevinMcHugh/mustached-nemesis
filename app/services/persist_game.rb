class PersistGame

  def initialize(params)
    @game = params[:game]
    @brains = params[:brains]
    @roles = params[:roles]
    @expansions = params[:expansions]
    @seed = params[:seed]
  end

  def execute
    gr = GameRecord.create(seed: @seed)
    @game.events.each_with_index do |event, index|
      EventRecord.create(game_record_id: gr.id, order: index, event_json: event.to_json)
    end
    @brains.each_with_index do |brain, index|
      won = !!game.winners.detect{ |player| player.role == @roles[index] && player.brain.class == brain }
      PlayerRecord.create(game_record_id: gr.id, order: index, brain: brain.to_s, role: @roles[index], won: won)
    end
    @expansions.each do |expansion|
      Expansion.create(game_record_id: gr.id, name: expansion)
    end
  end

end
