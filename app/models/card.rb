class Card
  require 'cards'
  MISSABLE =  [BangCard, PunchCard, SpringfieldCard]  #[bang! punch springfield gatling ]
  attr_accessor :suit, :number

  def type
    self.class
  end

  def initialize(suit, number)
    @suit = suit
    @number = number
  end

  def barrelable?
    MISSABLE.include?(type)
  end

  def explode?
    number >= 2 && number <= 9 && suit == "spade"
  end

  def still_in_jail?
    suit != "heart"
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
end