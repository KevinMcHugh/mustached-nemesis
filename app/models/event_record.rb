class EventRecord < ActiveRecord::Base
  belongs_to :game_record
  belongs_to :player_record
  belongs_to :target_player_record, class_name: 'PlayerRecord'

  @@eventtypes_to_emoji_strings = Hash.new

  def eventtype_with_emojis
    emoji_for_eventtype
  end

  def json
    @json ||= JSON.parse(event_json)
  end

  private
  def emoji_for_card(card)
    EmojiForCard.new(card).execute
  end

  def emoji_for_eventtype
    if eventtype_is_static?
      emoji_for_static_eventtypes[eventtype]
    elsif ['Heal::Event', 'Hit::Event'].include?(eventtype)
      base = eventtype == 'Heal::Event' ? 'hospital' : 'boom'
      [base] + json['@health'].to_i.times.map {'heart'}
    elsif eventtype == 'Jail::Event'
      [json['@still_in_jail'] == true ? 'lock' : 'unlock']
    elsif eventtype == 'TapBadge::Event'
      ['name_badge'] + [json['@success'] ? '+1' : '-1']
    elsif ['PlayAndDiscard::Event', 'Discard::Event', 'Equip::Event'].include?(eventtype)
      card = json['@card']
      emoji_for_static_eventtypes[eventtype] + emoji_for_card(card)
    elsif eventtype == 'NewRoundStartedEvent'
      state = json['@round'] % 24
      [clock_states[state - 1]]
    else
      []
    end
  end

  def clock_states
    @@clock_states ||= [
      'clock12','clock1230',
      'clock1', 'clock130',
      'clock2', 'clock230',
      'clock3', 'clock330',
      'clock4', 'clock430',
      'clock5', 'clock530',
      'clock6', 'clock630',
      'clock7', 'clock730',
      'clock8', 'clock830',
      'clock9', 'clock930',
      'clock10','clock1030',
      'clock11','clock1130']
  end

  def eventtype_is_static?
    @@eventtypes_to_emoji_strings.keys.include?(eventtype)
  end

  def emoji_for_static_eventtypes
    @@eventtypes_to_emoji_strings['PlayerKilledEvent']      ||= ['boom','boom','boom']
    @@eventtypes_to_emoji_strings['TargetOfBang::Event']    ||= ['gun']
    @@eventtypes_to_emoji_strings['DynamiteCheck::Event']   ||= ['bomb']
    @@eventtypes_to_emoji_strings['TargetOfIndians::Event'] ||= ['raised_hand']
    @@eventtypes_to_emoji_strings['TargetOfGatling::Event'] ||= ['gun','gun','gun']
    @@eventtypes_to_emoji_strings['TargetOfDuel::Event']    ||= ['cold_sweat']
    @@eventtypes_to_emoji_strings['GameOverEvent']          ||= ['fireworks','sparkler','checkered_flag','white_check_mark']
    @@eventtypes_to_emoji_strings['PlayAndDiscard::Event']  ||= ['arrow_forward', 'fast_forward']
    @@eventtypes_to_emoji_strings['Equip::Event']           ||= ['arrow_forward', 'arrow_up']
    @@eventtypes_to_emoji_strings['Discard::Event']         ||= ['fast_forward']
    @@eventtypes_to_emoji_strings['NewTurnStarted::Event']  ||= ['arrow_heading_down']
    @@eventtypes_to_emoji_strings['NewGameStartedEvent']    ||= ['alarm_clock']
    @@eventtypes_to_emoji_strings['CardRevealedEvent']      ||= ['flower_playing_cards', 'question']
    @@eventtypes_to_emoji_strings
  end
end