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
      b = @brains.shift.new(role)
      c = Character.const_get(b.choose_character(@characters.shift, @characters.shift))
      b.player = c.new(role, @deck, b)
      if role == 'sheriff'
        players.unshift(b.player)
      else
        players << b.player
      end
    end
    right_player = players.last
    players.each  do |player|
      player.right = right_player
      right_player = player
    end
    Game.new(players, @deck).start
  end
end
