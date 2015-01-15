module GameRecordsHelper

  def format_event_record(event_record)
    hash = {}
    hash[:target_player] = event_record.target_player_record.to_s if event_record.target_player_record
    json = JSON.parse(event_record.event_json)
    hash[:card] = json['@card']['@type'] if json['@card']
    target_card = json['@target_card'] if json['@target_card']
    target_card = target_card['@type'] if target_card && target_card['@type']
    hash[:target_card] = target_card if target_card && hash[:card] == 'CatBalouCard'
    hash.empty? ? nil : hash
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
      'Heal::Event'            => 'success',
      'NewGameStartedEvent'    => 'success',
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
end
