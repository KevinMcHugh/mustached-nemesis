class CreateGame
  def initialize(params)
    @role_index = 0
    @params = params
  end

  def execute
    players = users.map { |user| Player.create(user, next_role) }
    Game.create(players, deck)
  end

  private
  def next_role
    roles[@role_index+=1]
  end

  def roles
    @roles ||= Role.for_players(users.length).shuffle
  end

  def users
    @users ||= params[:users]
  end

  def deck
    @deck ||= Deck.new
  end
end
