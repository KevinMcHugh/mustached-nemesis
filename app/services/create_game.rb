class CreateGame
  def initialize(params)
    @role_index = 0
    @params = params
    @seed = params[:seed] || Random.new.seed
    @random = Random.new(@seed)
    @initial_brains = params[:brains]
    @brains = params[:brains].shuffle(random: @random)
    @expansions = params[:expansions] || []
    @deck = Deck.new(seed: @random, expansions: @expansions)
    @roles = Game.all_roles.take(@brains.size)
    @persist = params[:persist]
  end

  def execute()
    players = []
    @characters = Character.constants.select { |c| Character.const_get(c).is_a?(Class) }
    @expansions.each do |expansion|
      expansion_module = (expansion.to_s.camelize + "Character").constantize
      @characters += expansion_module.constants.select { |c| expansion_module.const_get(c).is_a?(Class) }
    end
    @characters.sort.shuffle!(random: @random)
    @roles.shuffle!(random: Random.new(@seed + 42)).each do |role|
      brain = @brains.shift.new(role)
      choosing_from = [@characters.shift, @characters.shift]
      choice = brain.choose_character(choosing_from.first, choosing_from.second)
      character_class = Character.const_get(choice)
      player = character_class.new(role, @deck, brain)
      brain.player = PlayerAPI.new(player, brain)
      if role == 'sheriff'
        players.unshift(player)
      else
        players << player
      end
    end
    right_player = players.last
    players.each do |player|
      player.right = right_player
      right_player.left = player
      right_player = player
    end
    game = Game.new(players, @deck)
    game.start
    persist(game) if @persist
    game
  end
  def persist(game)
    gr = GameRecord.create(seed: @seed)
    game.events.each_with_index do |event, index|
      EventRecord.create(game_record_id: gr.id, order: index, event_json: event.to_json)
    end
    @brains.each_with_index do |brain, index|
      PlayerRecord.create(game_record_id: gr.id, order: index, brain: brain, role: @roles[index], won: true == game.winners.detect{ |player| player.role == @roles[index] && player.brain.class == brain } )
    end
    @expansions.each do |expansion|
      Expansion.create(game_record_id: gr.id, name: expansion)
    end
  end
end
