class EventRecord < ActiveRecord::Base
  belongs_to :game_record
  belongs_to :player_record
  belongs_to :target_player_record, class_name: 'PlayerRecord'
end