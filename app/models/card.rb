class Card
  require 'cards'
  GUN =  []
  MISSABLE =  [BangCard, PunchCard, SpringfieldCard, GatlingCard]  #[bang! punch springfield gatling ]

  attr_accessor :suit, :number

  def initialize(suit=nil, number=nil)
    @suit = suit
    @number = number
  end

  def no_range?
    false
  end

  def gun_range?
    false
  end
  def range
    1
  end

  def type
    self.class
  end

  def barrelable?
    MISSABLE.include?(type)
  end

  def missable?
    MISSABLE.include?(type)
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


  def self.beer_card
    BeerCard
  end
  def self.bang_card
    BangCard
  end
  def self.punch_card
    PunchCard
  end
  def self.springfield_card
    SpringfieldCard
  end
  def self.indians_card
    IndiansCard
  end
  def self.jail_card
    JailCard
  end
  def self.dynamite_card
    DynamiteCard
  end
  def self.gatling_card
    GatlingCard
  end
  def self.missed_card
    MissedCard
  end
end