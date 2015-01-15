class EventRecord < ActiveRecord::Base
  belongs_to :game_record
  belongs_to :player_record
  belongs_to :target_player_record, class_name: 'PlayerRecord'

  def eventtype_with_emojis
    eventtypes_to_emoji_strings = Hash.new([])
    eventtypes_to_emoji_strings['PlayerKilledEvent']      = ['boom','boom','boom']
    eventtypes_to_emoji_strings['Heal::Event']            = ['hospital']
    eventtypes_to_emoji_strings['TargetOfBang::Event']    = ['gun']
    eventtypes_to_emoji_strings['DynamiteCheck::Event']   = ['bomb']
    eventtypes_to_emoji_strings['Hit::Event']             = ['boom']
    eventtypes_to_emoji_strings['TargetOfIndians::Event'] = ['raised_hand']
    eventtypes_to_emoji_strings['TargetOfGatling::Event'] = ['gun','gun','gun']
    eventtypes_to_emoji_strings['TargetOfDuel::Event']    = ['cold_sweat']
    eventtypes_to_emoji_strings['TapBadge::Event']        = ['name_badge']
    eventtypes_to_emoji_strings['GameOverEvent']          = ['fireworks','sparkler','checkered_flag','white_check_mark']
    eventtypes_to_emoji_strings['Jail::Event']            = [emoji_for_jail]

    if ['PlayAndDiscard::Event', 'Discard::Event', 'Equip::Event'].include?(eventtype)
      card = json['@card']
      eventtypes_to_emoji_strings[eventtype] = emoji_for_card(card)
    end
    eventtypes_to_emoji_strings[eventtype]
  end

  def emoji_for_card(card)
    suit = card['@suit'] + 's'
    card_specific_emojis = {
      'BeerCard'         => ['beer'],
      'SaloonCard'       => ['beers'],
      'CatBalouCard'     => ['cat'],
      'JailCard'         => ['lock'],
      'IndiansCard'      => ['raised_hand'],
      'MustangCard'      => ['racehorse'],
      'BangCard'         => ['exclamation'],
      'GeneralStoreCard' => ['convenience_store'],
      'GatlingCard'      => ['gun''gun','gun'],
      'DuelCard'         => ['cold_sweat'],
      'VolcanicCard'     => ['eight_spoked_asterisk','one','gun'],
      'SchofieldCard'    => ['two','gun'],
      'RemingtonCard'    => ['three','gun'],
      'RevCarbineCard'   => ['four','gun'],
      'WinchesterCard'   => ['five','gun'],
      'MissedCard'       => ['no_pedestrians'],
      'PanicCard'        => ['no_good'],
      'ScopeCard'        => ['telescope'],
      'WellsFargoCard'   => ['truck']
    }
    card_specific_emoji = card_specific_emojis[card['@type']] || []
    card_specific_emoji << "#{suit}"
  end

  def emoji_for_jail
    json['@still_in_jail'] == true ? 'lock' : 'unlock'
  end

  def json
    @json ||= JSON.parse(event_json)
  end
end