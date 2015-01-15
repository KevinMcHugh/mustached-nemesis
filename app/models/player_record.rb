class PlayerRecord < ActiveRecord::Base
  belongs_to :game_record
  def to_s
    "#{brain}|#{role}|#{character}"
  end

  def to_s_with_emoji_string
    "#{emoji_string_for_role}|#{brain}|#{character}"
  end

  def emoji_string_for_role
    { 'sheriff'  => ':star:',
      'deputy'   => ':cop:',
      'outlaw'   => ':japanese_goblin:',
      'renegade' => ':sunglasses:'
    }[role]
  end
end
