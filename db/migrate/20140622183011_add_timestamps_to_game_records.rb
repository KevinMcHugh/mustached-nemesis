class AddTimestampsToGameRecords < ActiveRecord::Migration
  def change
    add_column(:game_records, :created_at, :datetime)
    add_column(:game_records, :updated_at, :datetime)
  end
end
