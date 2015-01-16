class ChangeGameRecordSeedToText < ActiveRecord::Migration
  def change
    change_column :game_records, :seed, :text
  end
end
