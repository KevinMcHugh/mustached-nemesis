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
    elsif eventtype == 'Heal::Event'
      ['hospital'] + json['@health'].to_i.times.map {':heart:'}
    elsif eventtype == 'Jail::Event'
      [json['@still_in_jail'] == true ? 'lock' : 'unlock']
    elsif ['PlayAndDiscard::Event', 'Discard::Event', 'Equip::Event'].include?(eventtype)
      card = json['@card']
      emoji_for_static_eventtypes[eventtype] + emoji_for_card(card)
    else
      []
    end
  end

  def eventtype_is_static?
    @@eventtypes_to_emoji_strings.keys.include?(eventtype)
  end

  def emoji_for_static_eventtypes
    @@eventtypes_to_emoji_strings['PlayerKilledEvent']      ||= ['boom','boom','boom']
    @@eventtypes_to_emoji_strings['TargetOfBang::Event']    ||= ['gun']
    @@eventtypes_to_emoji_strings['DynamiteCheck::Event']   ||= ['bomb']
    @@eventtypes_to_emoji_strings['Hit::Event']             ||= ['boom']
    @@eventtypes_to_emoji_strings['TargetOfIndians::Event'] ||= ['raised_hand']
    @@eventtypes_to_emoji_strings['TargetOfGatling::Event'] ||= ['gun','gun','gun']
    @@eventtypes_to_emoji_strings['TargetOfDuel::Event']    ||= ['cold_sweat']
    @@eventtypes_to_emoji_strings['TapBadge::Event']        ||= ['name_badge']
    @@eventtypes_to_emoji_strings['GameOverEvent']          ||= ['fireworks','sparkler','checkered_flag','white_check_mark']
    @@eventtypes_to_emoji_strings['PlayAndDiscard::Event']  ||= ['arrow_forward', 'fast_forward']
    @@eventtypes_to_emoji_strings['Equip::Event']           ||= ['arrow_forward', 'arrow_up']
    @@eventtypes_to_emoji_strings['Discard::Event']         ||= ['fast_forward']
    @@eventtypes_to_emoji_strings
  end
end