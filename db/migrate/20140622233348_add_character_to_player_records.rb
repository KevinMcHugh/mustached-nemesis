class AddCharacterToPlayerRecords < ActiveRecord::Migration
  def change
    add_column :player_records, :character, :string
  end
end
