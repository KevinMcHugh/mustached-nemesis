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
    @game.events.each_with_index do |event, index|
      EventRecord.create(game_record_id: gr.id, order: index, event_json: event.to_json)
    end
    # binding.pry
    @brains.each_with_index do |brain, index|
      won = @game.winners.map(&:class).map(&:to_s).include?(brain.player.character)
      PlayerRecord.create(game_record_id: gr.id, order: index, brain: brain.class.to_s,
        role: brain.role, won: won, character: brain.player.character)
    end
    @expansions.each do |expansion|
      Expansion.create(game_record_id: gr.id, name: expansion)
    end
  end

end
