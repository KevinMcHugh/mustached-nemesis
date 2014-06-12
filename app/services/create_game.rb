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
      b.player = Character.const_get(b.choose_character(@characters.shift, @characters.shift)).new(role, @deck, b)
      players << b.player
    end
    Game.new(players, @deck).start
  end
end
