class AddPlayerRecordToEventRecord < ActiveRecord::Migration
  def change
    add_reference :event_records, :player_record
    add_reference :event_records, :target_player_record
  end
end
