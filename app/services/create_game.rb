class CreateGame
  def initialize(params)
    @role_index = 0
    @params = params
    @brains = params[:brains]
    @deck = Deck.new(params[:seed], params[:expansions])
    @roles = Game.all_roles.take(@brains.size)
  end

  def execute()
    players = []
    @characters = Character.constants.select { |c| Character.const_get(c).is_a?(Class) }.shuffle
    @roles.shuffle.each do |role|
      brain = @brains.shift.new(role)
      character_class = Character.const_get(brain.choose_character(@characters.shift, @characters.shift))
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
      right_player = player
    end
    Game.new(players, @deck).start
  end
end
