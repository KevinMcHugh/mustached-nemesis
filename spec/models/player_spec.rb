require 'spec_helper'

describe Player do
  let(:deck) { Deck.new }
  let(:sheriff) { described_class.new("sheriff", nil, deck) }
  let(:outlaw_1) { described_class.new("outlaw", nil, deck) }
  let(:outlaw_2) { described_class.new("outlaw", nil, deck) }
  let(:renegade) { described_class.new("renagade", nil, deck) }
  before do
    sheriff.left = renegade
    outlaw_1.left = sheriff
    outlaw_2.left = outlaw_1
    renegade.left = outlaw_2
  end

  it "sets left and right" do
    expect(sheriff.right).to eq(outlaw_1)
    expect(outlaw_1.right).to eq(outlaw_2)
    expect(outlaw_2.right).to eq(renegade)
    expect(renegade.right).to eq(sheriff)
  end

  describe "#distance_to" do
    it 'sets distance' do
      expect(sheriff.distance_to(renegade)).to eq(1)
      expect(sheriff.distance_to(outlaw_2)).to eq(2)
    end
    it 'takes into account range increases' do
      allow(sheriff).to receive(:range_increase).and_return(1)
      expect(outlaw_1.distance_to(sheriff)).to eq(2)
    end
    it 'takes into account range decreases' do
      allow(sheriff).to receive(:range_decrease).and_return(1)
      expect(sheriff.distance_to(outlaw_2)).to eq(1)
    end
  end

  describe "#in_range?" do
    let(:bang_card) { BangCard.new("diamonds", 5) }
    let(:beer_card) { BeerCard.new }
    let(:punch_card) { PunchCard.new("clubs") }

    context "beer card" do
      it 'always returns true for beer cards' do
        expect(sheriff.in_range?(beer_card, sheriff)).to be_true
      end
    end

    context "bang card, no gun" do
      it "is true if the player is in range" do
        expect(sheriff.in_range?(bang_card, outlaw_1)).to be_true
        expect(sheriff.in_range?(bang_card, renegade)).to be_true
      end
      it "is false if the player isn't in range" do
        expect(sheriff.in_range?(bang_card, outlaw_2)).to be_false
      end
    end

    context "bang card, with gun" do
      before { allow(sheriff).to receive(:gun_range).and_return(2) }
      it "is true now for all players in range" do
        expect(sheriff.in_range?(bang_card, outlaw_1)).to be_true
        expect(sheriff.in_range?(bang_card, outlaw_2)).to be_true
        expect(sheriff.in_range?(bang_card, renegade)).to be_true
      end
    end

    context "punch card always has a range of 1, even with gun" do
      before { allow(sheriff).to receive(:gun_range).and_return(2) }
      it "is true if the player is in range" do
        expect(sheriff.in_range?(punch_card, outlaw_1)).to be_true
        expect(sheriff.in_range?(punch_card, renegade)).to be_true
      end
      it "is false if the player isn't in range" do
        expect(sheriff.in_range?(punch_card, outlaw_2)).to be_false
      end
    end
  end

  describe '#sheriff?' do
    context 'when the player is not the sheriff' do
      it 'returns false' do
        expect(outlaw_1.sheriff?).to be_false
      end
    end
    context 'when the player is the sheriff' do
      it 'returns false' do
        expect(sheriff.sheriff?).to be_true
      end
    end
  end

  describe "#barrel" do
    let(:indians_card) { IndiansCard.new }
    let(:bang_card) { BangCard.new }
    it 'always returns false if the card is not barrelable' do
      expect(sheriff.barrel(indians_card)).to be_false
    end
    it 'returns true if the card is barrelable and a heart is drawn' do
      allow(sheriff).to receive(:draw!).and_return(Card.new('heart'))
      expect(sheriff.barrel(bang_card)).to be_true
    end
    it 'returns false if the card is barrelable and a heart is not drawn' do
      allow(sheriff).to receive(:draw!).and_return(Card.new('spade'))
      expect(sheriff.barrel(bang_card)).to be_false
    end
  end

  describe "#jail" do
    let(:jail_card) { JailCard.new }

    it 'return false if player is not in jail' do
      expect(outlaw_1.jail).to be_false
    end
    it 'returns true if the draw is not a heart' do
      outlaw_1.in_play << jail_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade'))
      expect(outlaw_1.jail).to be_true
    end
    it 'returns false if the draw is a heart' do
      outlaw_1.in_play << jail_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('heart'))
      expect(outlaw_1.jail).to be_false
    end
    it "removes the jail from in play and adds it to the discard" do
      outlaw_1.in_play << jail_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade'))
      outlaw_1.jail
      expect(outlaw_1.in_play.include?(jail_card)).to be_false
      expect(deck.discard.last).to be jail_card
    end
  end

  describe "#dynamite" do
    let(:dynamite_card) { DynamiteCard.new }

    it 'does not damage the player if there is no dynamite' do
      health = outlaw_1.health
      outlaw_1.dynamite
      expect(outlaw_1.health).to eq health
    end
    it 'does not damage the player if the draw is not 2-9 spades and passes' do
      health = outlaw_1.health
      outlaw_1.in_play << dynamite_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade', 10))
      outlaw_1.dynamite
      expect(outlaw_1.health).to eq health
      expect(outlaw_1.left.in_play.include?(dynamite_card)).to be_true
    end
    it 'does damage the player if the draw is 2-9 spades, and discards' do
      health = outlaw_1.health
      outlaw_1.in_play << dynamite_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade', 9))
      outlaw_1.dynamite
      expect(outlaw_1.health).to eq (health - 3)
      expect(deck.discard.last).to be dynamite_card
    end
  end
end
