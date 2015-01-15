module GameRecordsHelper

  def format_event_record(event_record)
    hash = {}
    if event_record.target_player_record
      target_player = event_record.target_player_record.to_s_with_emoji_string
      hash[':sweat:'] = target_player
    end
    json = event_record.json
    hash[':flower_playing_cards:'] = EmojiForCard.new(json['@card'], true).execute if json['@card']
    target_card = json['@target_card'] if json['@target_card']
    target_card = target_card['@type'] if target_card && target_card['@type']
    if target_card && json['@card']['@type'] == 'CatBalouCard'
      hash[':dart::flower_playing_cards:'] = EmojiForCard.new(target_card, true).execute
    end
    hash[:still_in_jail] = json['@still_in_jail'] if json['@still_in_jail']
    hash[:winners] = json['winners'] if json['winners']
    hash
  end

  def class_for_event(event_record)
    eventtypes_to_classes = {
      'NewRoundStartedEvent'   => 'info',
      'NewTurnStarted::Event'  => 'info',
      'Discard::Event'         => 'active',
      'TapBadge::Event'        => 'active',
      'TargetOfDuel::Event'    => 'warning',
      'TargetOfBang::Event'    => 'warning',
      'TargetOfIndians::Event' => 'warning',
      'DynamiteCheck::Event'   => 'warning',
      'Jail::Event'            => 'warning',
      'Hit::Event'             => 'danger',
      'PlayerKilledEvent'      => 'danger',
      'Heal::Event'            => 'success',
      'NewGameStartedEvent'    => 'success',
      'GameOverEvent'          => 'success'
    }
    eventtypes_to_classes[event_record.eventtype]
  end

  def class_for_game(game_record)
    roles_to_classes = {
      ['sheriff']           => 'success',
      ['deputy', 'sheriff'] => 'success',
      ['outlaw']            => 'danger',
      ['renegade']          => 'warning'
    }
    winners = game_record.winners_roles
    roles_to_classes[winners]
  end

  def class_for_player(player_record)
    player_record.won? ? 'success' : 'danger'
  end

  def emoji_for(emoji_strings)
    emoji_strings.map do |emoji_string|
      emoji = emoji_m(emoji_string)
      (emoji ? image(emoji_string, emoji) : emoji_string).html_safe
    end.reduce(:+)
  end

  def emojify(content)
    content.to_s.gsub(/:([\w+-]+):/) do |match|
      emoji = Emoji.find_by_alias($1)
      image($1, emoji) if emoji
    end.html_safe
  end

  def image(title, emoji)
    @@images ||= {}
    @@images[[title, emoji]] ||=
      %(<img alt="#{title}" src="#{asset_path("images/emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
    @@images[[title, emoji]]
  end

  def emoji_m(emoji_string)
    @@emojis ||= {}
    @@emojis[emoji_string] ||= Emoji.find_by_alias(emoji_string)
    @@emojis[emoji_string]
  end
end
