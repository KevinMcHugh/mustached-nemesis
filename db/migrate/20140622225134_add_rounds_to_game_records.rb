class AddRoundsToGameRecords < ActiveRecord::Migration
  def change
    add_column :game_records, :rounds, :integer
  end
end
