class EventRecord < ActiveRecord::Base
  belongs_to :game_record
  belongs_to :player_record
  belongs_to :target_player_record, class_name: 'PlayerRecord'

  def eventtype_with_emojis
    EmojiForEvent.new(self).execute
  end

  def json
    @json ||= JSON.parse(event_json)
  end
end