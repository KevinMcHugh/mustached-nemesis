## STANDARD BANG!:
# Action Cards:
#   Bang 2-9♣, 5♣, 6♣, K♣, 2-A♦, Q-K♥, 8♠, A♠
#   Gatling 10♥
#   Indians 5♦, A♦, K♦
#   Duel Q♦, J♠, 8♣
#   Missed 10-A♣, 2-8♠, 8♦
#   Beer 6♥, 6♥ , 7-J♥, 6♠

#   Saloon 5♥
#   Cat Balou 9♦, 10♦, J♦, K♥, 8♣
#   Panic! J♥, Q♥, K♥, 8♦
#   Stagecoach 9♠ (x2)
#   Wells Fargo 3♥
#   General Store 9♣, Q♠, A♠
# Equipment Cards:

#   Volcanic 10♠, 10♣
#   Schofield K♠, J♣, Q♣
#   Winchester 8♠
#   Remington K♣, 5♦
#   Rev. Carbine A♣, 5♠
#   Scope A♠
#   Binoculars 10♦
#   Mustang 5♥, 8♥, 9♥
#   Hideout K♦
#   Dynamite 10♣, 2♥
#   Jail 10♠, 4♥, J♠
#   Barrel Q♠, K♠, A♣


class Deck
  require 'card'
  def initialize(seed = nil, expansions = nil)
    cards =
    @seed = seed ? seed : Random.new.seed
    @draw = create_deck.shuffle(random: Random.new(@seed))
    @discard = []
  end


  #TODO figure out a way to assign suits
  def create_deck(expansions=[])
    cards = []
    #   Bang 2-9♣, 2-A♦, Q-K♥,  A♠
    13.times { |n| cards << BangCard.new("diamond", n+2 ) }
    7.times { |n| cards << BangCard.new("club", n+2 ) }
    cards << BangCard.new("heart", 12)
    cards << BangCard.new("heart", 13)
    cards << BangCard.new("spade", 14)
    #   Gatling 10♥
    cards << GatlingCard.new("heart", 10)
    #   Indians  A♦, K♦
    cards << IndiansCard.new("diamond", 13)
    cards << IndiansCard.new("diamond", 14)
    #   Beer 6♥, 7-J♥
    5.times { |n| cards << BeerCard.new("heart", n+7) }
    cards << BeerCard.new("heart", 6)

    #   Missed 10-A♣, 2-8♠
    4.times { |n| cards << MissedCard.new("club", n+10) }
    6.times { |n| cards << MissedCard.new("spade", n+2) }
    #   Duel Q♦, J♠, 8♣
    cards << DuelCard.new("diamond", 12)
    cards << DuelCard.new("spade", 11)
    cards << DuelCard.new("club", 8)
    #   Saloon 5♥
    cards << SaloonCard.new("heart", 5)
    #   Stagecoach 9♠ (x2)
     2.times { cards << StageCoachCard.new("spade", 9) }
    #   Wells Fargo 3♥
    cards << WellsFargoCard.new("heart", 3)
    #   Cat Balou 9♦, 10♦, J♦, K♥
    cards << CatBalouCard.new("diamond", 9)
    cards << CatBalouCard.new("diamond", 10)
    cards << CatBalouCard.new("diamond", 11)
    cards << CatBalouCard.new("heart", 13)
    #   Panic! J♥, Q♥, K♥, 8♦
    cards << PanicCard.new("heart", 11)
    cards << PanicCard.new("heart", 12)
    cards << PanicCard.new("heart", 13)
    cards << PanicCard.new("diamond", 8)
    #   General Store 9♣, Q♠

    #   Jail 10♠, 4♥, J♠
    cards << JailCard.new("spade", 10)
    cards << JailCard.new("spade", 11)
    cards << JailCard.new("heart", 4)
    #   Dynamite 2♥
    cards << DynamiteCard.new("heart", 2)
    #   Barrel Q♠, K♠
    cards << BarrelCard.new("spade", 12)
    cards << BarrelCard.new("spade", 13)
    #   Scope A♠
    cards << ScopeCard.new("spade", 14)
    #   Mustang 8♥, 9♥
    cards << MustangCard.new("heart", 8)
    cards << MustangCard.new("heart", 9)
    #   Remington K♣
    cards << RemingtonCard.new("club", 13)
    #   Rev. Carbine A♣
    cards << RevCarbineCard.new("club", 14)
    #   Volcanic 10♠, 10♣
    #   Schofield K♠, J♣, Q♣
    #   Winchester 8♠

    if expansions.include?(:dodge_city)
      #   Bang 5♣, 6♣, K♣, 8♠fff
      cards << BangCard.new("club", 5)
      cards << BangCard.new("club", 6)
      cards << BangCard.new("club", 13)
      cards << BangCard.new("spade", 8)
      #   Punch 10♠
      cards << PunchCard.new("spade", 10)
      #   Indians 5♦
      cards << IndiansCard.new("diamond", 5)
      #   Missed 8♦
      cards << MissedCard.new("diamond", 8)
      #   Beer 6♥, 6♠
      cards << BeerCard.new("spade", 6)
      cards << BeerCard.new("heart", 6)
      #   Binoculars 10♦
      cards << BinocularsCard.new("diamond", 10)
      #   Hideout K♦
      cards << HideoutCard.new("diamond", 13)
      #   Mustang 5♥
      cards << MustangCard.new("heart", 5)
      #   Barrel A♣
      cards << BarrelCard.new("club", 14)
      #   Dynamite 10♣,
      cards << DynamiteCard.new("club", 10)
      #   Rev. Carbine 5♠
      cards << RevCarbineCard.new("spade", 5)
      #   Remingtion 6♦
      cards << RemingtonCard.new("diamond", 6)
      #   Springfield 10♠
      #   Ragtime 9♥
      #   Whiskey Q♥
      #   GeneralStore A♠
      #   Dodge 7♦, K♥
      #   Panic J♥
      #   Cat Balou 8♣
      #   Tequila 9♣
      #   Brawl J♠
    end
    cards
  end

  def deal_to(players)
    players.each do |player|
      player.hand += take(player.max_health)
    end
  end

  def take(number_of_cards=1)
    check_to_shuffle.pop(number_of_cards)
  end

  def draw!
    card = check_to_shuffle.pop
    discard.push(card)
    card
  end

  def check_to_shuffle
    return draw unless draw.empty?
    @draw = discard.shuffle
    discard.clear
    draw
  end


  def most_recently_discarded
    discard.last
  end

  def top_card
    check_to_shuffle.first
  end

  attr_reader :draw, :discard

end
