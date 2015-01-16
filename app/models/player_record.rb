class PlayerRecord < ActiveRecord::Base
  belongs_to :game_record
  def to_s
    "#{brain}|#{role}|#{character}"
  end

  def to_s_with_emoji_string
    ":#{emoji_string_for_role}:|#{try_brain_emoji}|#{character_emoji}"
  end

  def emoji_string_for_role
    { 'sheriff'  => 'star',
      'deputy'   => 'cop',
      'outlaw'   => 'japanese_goblin',
      'renegade' => 'sunglasses'
    }[role]
  end

  def brain_emoji
    @brain_emoji ||= brain.constantize.try(:emoji) || ''
  end

  def try_brain_emoji
    brain_emoji.empty? ? brain : brain_emoji
  end

  def character_emoji
    @character_emoji ||= character.constantize.try(:emoji) || ''
  end
end
