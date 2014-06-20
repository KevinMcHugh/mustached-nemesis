class GameRecord < ActiveRecord::Migration
  def change
     create_table "game_records", force: true do |t|
      t.integer "seed"
     end
     create_table "event_records", force: true do |t|
      t.integer "game_record_id"
      t.integer "order"
      t.text "event_json"
     end
     create_table "player_records", force: true do |t|
      t.integer "game_record_id"
      t.integer "order"
      t.string "brain"
      t.string "role"
      t.boolean "won"
     end
     create_table "expansions", force: true do |t|
      t.integer "game_record_id"
      t.string "name"
    end
  end
end
