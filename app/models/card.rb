class Card
  require 'cards'
  GUN =  [RevCarbineCard, RemingtonCard, SchofieldCard, WinchesterCard, VolcanicCard]
  MISSABLE =  [BangCard, PunchCard, SpringfieldCard, GatlingCard]
  RANGE_INCREASE = [MustangCard, HideoutCard]
  RANGE_DECREASE = [ScopeCard, BinocularsCard]
  attr_reader :suit, :number

  def initialize(suit=nil, number=nil)
    @suit = suit
    @number = number
  end

  def no_range?; false; end
  def gun_range?; false; end
  def range; 1; end

  def damage_dealing?; false; end
  def equipment?; false; end

  def type; self.class; end

  def barrelable?
    MISSABLE.include?(type)
  end

  def missable?
    MISSABLE.include?(type)
  end

  def range_increase?
    RANGE_INCREASE.include?(type)
  end

  def range_decrease?
    RANGE_DECREASE.include?(type)
  end

  def explode?
    number >= 2 && number <= 9 && suit == "spade"
  end

  def still_in_jail?
    suit != "heart"
  end
  def barreled?
    suit == "heart"
  end

  def gun?
    GUN.include?(self.class)
  end

  def self.beer_card; BeerCard; end
  def self.bang_card; BangCard; end
  def self.indians_card; IndiansCard; end
  def self.gatling_card; GatlingCard; end
  def self.missed_card; MissedCard; end
  def self.duel_card; DuelCard; end
  def self.saloon_card; SaloonCard; end
  def self.stage_coach_card; StageCoachCard; end
  def self.wells_fargo_card; WellsFargoCard; end
  def self.cat_balou_card; CatBalouCard; end
  def self.panic_card; PanicCard; end

  def self.scope_card; ScopeCard; end
  def self.mustang_card; MustangCard; end
  def self.revcarbine_card; RevCarbineCard; end
  def self.remington_card; RemingtonCard; end
  def self.schofield_card; SchofieldCard; end
  def self.winchester_card; WinchesterCard; end
  def self.volcanic_card; VolcanicCard; end
  def self.jail_card; JailCard; end
  def self.dynamite_card; DynamiteCard; end
  def self.barrel_card; BarrelCard; end
## Dodge City Cards
  def self.punch_card; PunchCard; end
  def self.springfield_card; SpringfieldCard; end
  def self.hideout_card; HideoutCard; end
  def self.binoculars_card; BinocularsCard; end

end
