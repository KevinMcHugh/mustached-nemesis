class PlayerRecord < ActiveRecord::Base
  belongs_to :game_record
  def to_s
    "#{brain}|#{role}|#{character}"
  end
end
