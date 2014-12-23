class GameRecord < ActiveRecord::Base
  has_many :event_records
  has_many :player_records
  has_many :expansions

  def winners
    player_records.find_all(&:won?)
  end
end
