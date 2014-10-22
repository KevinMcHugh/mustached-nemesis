class CreateGame
  def initialize(params)
    @role_index = 0
    @params = params
    @seed = params[:seed] || Random.new.seed
    @random = Random.new(@seed)
    @brains = params[:brains].shuffle(random: @random).map do |brain_class|
      brain_class.new
    end
    @brains_copy = @brains.clone
    @brains_to_players = {}
    @expansions = params[:expansions] || []
    @deck = Deck.new(seed: @random, expansions: @expansions)
    @roles = Game.all_roles.take(@brains.size)
    @persist = params[:persist]
  end

  def execute
    players = []
    @characters = Character.all
    load_expansions
    @characters.sort!.shuffle!(random: @random)
    @roles.shuffle!(random: Random.new(@seed + 42)).each do |role|
      brain = @brains.shift
      brain.role = role
      choosing_from = [@characters.shift, @characters.shift]
      player = character_class(choosing_from, brain).new(role, @deck, brain)
      @brains_to_players[brain] = player
      brain.player = PlayerAPI.new(player, brain)
      if role == 'sheriff'
        players.unshift(player)
      else
        players << player
      end
    end
    connect(players)
    game = Game.new(players, @deck)
    game.start
    persist(game) if @persist
    game
  end

  private
  def load_expansions
    @expansions.each do |expansion|
      expansion_module = (expansion.to_s.camelize + "Character").constantize
      @characters += expansion_module.constants.select { |c| expansion_module.const_get(c).is_a?(Class) }
    end
  end

  def connect(players)
    right_player = players.last
    players.each do |player|
      player.right = right_player
      right_player.left = player
      right_player = player
    end
  end

  def character_class(choosing_from, brain)
    choice = brain.choose_character(choosing_from.first, choosing_from.second)
    Character.const_get(choice)
  end

  def persist(game)
    options = {game: game, brains: @brains_copy, seed: @seed, expansions: @expansions, brains_to_players: @brains_to_players}
    PersistGame.new(options).execute
  end
end
