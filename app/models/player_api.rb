class PlayerAPI

  def initialize(player, brain)
    @player = player
    @brain = brain
    @dtos_to_players = Hash.new { |hash, key| hash[key] = find_player(key)}
  end

  def from_hand(card_type)
    @player.from_hand(card_type)
  end

  def from_play(card_type)
    @player.from_play(card_type)
  end

  def play_card(card, target_player=nil, target_card=nil)
    begin
      if target_player
        target_player = @dtos_to_players[target_player]
      end
      if card.equipment?
        card.play(@player, target_player, target_card)
      else
        @player.play_and_discard(card, target_player, target_card)
      end
    rescue TooManyBangsPlayedException => e
      @player.discard(card)
    rescue OutOfRangeException => e
      @player.discard(card)
    rescue => e
      @player.discard(card)
    end
  end

  def hand
    @player.hand.clone
  end

  def in_play
    @player.in_play.clone
  end

  def players
    @player.players.map { |p| PlayerDTO.new(p, @player) }
  end

  def players_in_range_of(card)
    players.find_all { |p| @player.in_range?(card, @dtos_to_players[p])}
  end

  def character; @player.class.to_s; end
  def health; @player.health; end

  private
  attr_reader :brain
  def instance_variable_get(variable); end #hahaha, eat it.
  def find_player(player_dto)
    @player.players.find { |p| p.class == player_dto.name }
  end
end
