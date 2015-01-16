class EmojiForCard

  attr_reader :card, :colonize
  def initialize(card, colonize=false)
    @card     = card
    @colonize = colonize
  end

  def execute
    if colonize
      colonized = emoji.map {|e| ":#{e}:" }
      colonized.reduce(:+)
    else
      emoji
    end
  end

  private
  def number
    numerals_to_strings = {
      2  => ['two'],
      3  => ['three'],
      4  => ['four'],
      5  => ['five'],
      6  => ['six'],
      7  => ['seven'],
      8  => ['eight'],
      9  => ['nine'],
      10 => ['one', 'zero'],
      11 => ['jack_o_lantern'],
      12 => ['crown', 'woman'],
      13 => ['crown', 'man'],
      14 => ['rocket']
    }
    numerals_to_strings[card['@number']]
  end

  def emoji
    return ['hand'] if card == 'hand'
    suit = card['@suit'] + 's'
    card_specific_emojis = {
      'BeerCard'         => ['beer'],
      'SaloonCard'       => ['beers'],
      'CatBalouCard'     => ['cat'],
      'JailCard'         => ['lock'],
      'IndiansCard'      => ['raised_hand'],
      'MustangCard'      => ['racehorse'],
      'BangCard'         => ['exclamation'],
      'GeneralStoreCard' => ['convenience_store'],
      'GatlingCard'      => ['gun','gun','gun'],
      'DuelCard'         => ['cold_sweat'],
      'VolcanicCard'     => ['eight_spoked_asterisk','one','gun'],
      'SchofieldCard'    => ['two','gun'],
      'RemingtonCard'    => ['three','gun'],
      'RevCarbineCard'   => ['four','gun'],
      'WinchesterCard'   => ['five','gun'],
      'MissedCard'       => ['cloud'],
      'PanicCard'        => ['trollface'],
      'ScopeCard'        => ['telescope'],
      'WellsFargoCard'   => ['truck']
    }
    card_specific_emoji = card_specific_emojis[card['@type']] || []
    card_specific_emoji += [number, suit].flatten
    card_specific_emoji
  end
end