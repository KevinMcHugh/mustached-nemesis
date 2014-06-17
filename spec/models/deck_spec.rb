require 'spec_helper'
describe Deck do
  let(:deck) { Deck.new }
  let(:seeded_deck) { Deck.new(seed:123) }
  let(:dodge_city_deck) { Deck.new(expansions:[:dodge_city]) }
  it "should create the deck" do
    expect(deck.draw.size).to eq 80
    # 2-7 1x of each 8-A 2x of each
    expect(deck.draw.select{|card| card.suit == "heart"}.size).to eq 20
    expect(deck.draw.select{|card| card.suit == "diamond"}.size).to eq 20
    expect(deck.draw.select{|card| card.suit == "spade"}.size).to eq 20
    expect(deck.draw.select{|card| card.suit == "club"}.size).to eq 20
  end
  it "should shuffle the deck" do
    deck_2 = Deck.new
    # Does not keep order
    expect(deck.draw.map(&:class)).to_not eq deck_2.draw.map(&:class)
    expect(deck.draw.map(&:suit)).to_not eq deck_2.draw.map(&:suit)
    expect(deck.draw.map(&:number)).to_not eq deck_2.draw.map(&:number)
    # Keeps elements
    expect(deck.draw.map(&:class)).to match_array deck_2.draw.map(&:class)
    expect(deck.draw.map(&:suit)).to match_array deck_2.draw.map(&:suit)
    expect(deck.draw.map(&:number)).to match_array deck_2.draw.map(&:number)
  end
  it "should shuffle in a repeatable manner" do
    deck_2 = Deck.new(seed:123)
    expect(seeded_deck.draw.map(&:class)).to eq deck_2.draw.map(&:class)
    expect(seeded_deck.draw.map(&:suit)).to eq deck_2.draw.map(&:suit)
    expect(seeded_deck.draw.map(&:number)).to eq deck_2.draw.map(&:number)
  end
  it "should allow for expansions to be provided" do
    expect(dodge_city_deck.draw.count).to eq 96
  end
  it "should deal to an array of players" do
    players = [Player.new("sheriff", deck)]
    4.times { players << Player.new("outlaw", deck) }
    deck.deal_to players
    players.each do |player|
      if player.role == "outlaw"
        expect(player.hand.size).to eq 4
      elsif player.role == "sheriff"
        expect(player.hand.size).to eq 5
      end
    end
  end
  it "should allow you to take the top card" do
    top_card  = deck.draw.last
    expect(deck.take).to eq [top_card]
  end
  it "should allow you to take the top x cards" do
    top_card  = deck.draw.last
    second_card  = deck.draw[-2]
    expect(deck.take(2)).to eq [top_card, second_card]
  end
  it "should draw! and discard a card" do
    x = nil
    top_card  = deck.draw.last
    expect{ x = deck.draw! }.to change{ deck.discard.count }.by(1)
    expect(x).to eq top_card
  end

  it "should return the most recently discarded card" do
    top_card  = deck.draw.last
    deck.draw!
    expect(deck.most_recently_discarded).to eq(top_card)
  end
  it "should return the top card" do
    top_card  = deck.draw.last
    expect(deck.top_card).to eq(top_card)
  end
  it "should shuffle the cards if the draw is empty" do
    (deck.discard << deck.draw.clone).flatten!
    deck.draw.clear
    expect(deck.draw).to eq []
    expect{ deck.check_to_shuffle }.to change{ deck.draw.size }.by(80)
    expect(deck.discard).to eq []
  end

end