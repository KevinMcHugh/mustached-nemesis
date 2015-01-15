module GameRecordsHelper

  def format_event_record(event_record)
    hash = {}
    hash[:target_player] = event_record.target_player_record.to_s if event_record.target_player_record
    json = JSON.parse(event_record.event_json)
    hash[:card] = json['@card']['@type'] if json['@card']
    target_card = json['@target_card'] if json['@target_card']
    hash[:target_card] = target_card['@type'] if target_card && target_card['@type']
    hash.empty? ? nil : hash
  end

  def class_for(event_record)
    eventtypes_to_classes = {
      'NewGameStartedEvent'    => 'info',
      'NewRoundStartedEvent'   => 'info',
      'NewTurnStarted::Event'  => 'info',
      'Discard::Event'         => 'active',
      'TargetOfDuel::Event'    => 'warning',
      'TargetOfBang::Event'    => 'warning',
      'TargetOfIndians::Event' => 'warning',
      'DynamiteCheck::Event'   => 'warning',
      'Jail::Event'            => 'warning',
      'Hit::Event'             => 'danger',
      'Heal::Event'            => 'success',
      'TapBadge::Event'        => 'success'
    }
    eventtypes_to_classes[event_record.eventtype]
  end
end
