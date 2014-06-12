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
    @roles.shuffle.each do |role|
      @brains.push(@brains.shift.new(role))
    end
    @characters = Character.constants.select { |c| Character.const_get(c).is_a?(Class) }.shuffle
    @brains.each do |brain|
      brain.player = brain.choose_character(@characters.shift, @characters.shift).new(brain.role, @deck)
      players << brain.player
    end
    Game.new(players, deck).start
  end

  private

end
