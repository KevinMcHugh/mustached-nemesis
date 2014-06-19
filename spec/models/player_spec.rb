require 'spec_helper'

describe Player do
  let(:deck) { Deck.new }
  let(:sheriff) { described_class.new("sheriff", deck) }
  let(:outlaw_1) { described_class.new("outlaw", deck) }
  let(:outlaw_2) { described_class.new("outlaw", deck) }
  let(:renegade) { described_class.new("renagade", deck) }
  before do
    sheriff.right  = outlaw_1
    outlaw_1.left = sheriff
    outlaw_1.right = outlaw_2
    outlaw_2.left = outlaw_1
    outlaw_2.right = renegade
    renegade.left = outlaw_2
    renegade.right = sheriff
    sheriff.left = renegade
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
      expect{outlaw_1.dynamite}.to change{outlaw_1.health}.by(0)
    end
    it 'does not damage the player if the draw is not 2-9 spades and passes' do
      outlaw_1.in_play << dynamite_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade', 10))
      expect{outlaw_1.dynamite}.to change{outlaw_1.health}.by(0)
      expect(outlaw_1.left.in_play.include?(dynamite_card)).to be_true
    end
    it 'does damage the player if the draw is 2-9 spades, and discards' do
      outlaw_1.in_play << dynamite_card
      allow(outlaw_1).to receive(:draw!).and_return(Card.new('spade', 9))
      expect{outlaw_1.dynamite}.to change{outlaw_1.health}.by(-3)
      expect(deck.discard.last).to be dynamite_card
    end
  end

  describe "#heal" do
    it "heals the player 1 point" do
      2.times { sheriff.hit! }
      expect{sheriff.heal}.to change{sheriff.health}.by(1)
    end
    it "does not heal more than maximum health" do
      expect{sheriff.heal}.to_not change{sheriff.health}
    end
    it "heals more than one at a time" do
      3.times { sheriff.hit! }
      expect{sheriff.heal(2)}.to change{sheriff.health}.by(2)
    end
  end

  describe "#dead?" do
    it "returns false if player has health" do
      expect(sheriff.dead?).to be_false
    end
    it "returns true if player has no health" do
      allow(sheriff).to receive(:health).and_return(0)
      expect(sheriff.dead?).to be_true
    end
  end

  describe "#hit" do
    it "deals one damage to the player" do
      expect{sheriff.hit!}.to change{sheriff.health}.by(-1)
    end
    it "kills player if it takes last health" do
      expect { 5.times { sheriff.hit!(outlaw_1) } }.to raise_error
      expect(sheriff.dead?).to be_true
    end
    it "plays beer to keep the player alive" do
      sheriff.hand << BeerCard.new
      5.times { sheriff.hit! }
      expect(sheriff.dead?).to be_false
    end
  end

  describe "#target_of_bang" do
    it "does not deal damage if barreled" do
      allow(sheriff).to receive(:draw!).and_return(Card.new("heart"))
      sheriff.in_play << BarrelCard.new
      expect(sheriff.target_of_bang(BangCard.new, outlaw_1)).to be_false
      expect{sheriff.target_of_bang(BangCard.new, outlaw_1)}.to_not change{sheriff.health}
    end

    context "not barreled" do
      before { allow(sheriff).to receive(:draw!).and_return(Card.new("spade")) }

      it "discards and does not deal damage if the response is a missed card from the hand" do
        mc = MissedCard.new
        sheriff.hand << mc
        allow(sheriff.brain).to receive(:target_of_bang).and_return([mc.to_dto])
        expect{sheriff.target_of_bang(BangCard.new, outlaw_1)}.to_not change{sheriff.health}
        expect(deck.discard.last).to be mc
      end
      it "hits if no response" do
        allow(sheriff.brain).to receive(:target_of_bang)
        expect{sheriff.target_of_bang(BangCard.new, outlaw_1)}.to change{sheriff.health}.by(-1)
      end
      it "hits if miss card is faked" do
        allow(sheriff.brain).to receive(:target_of_bang).and_return([MissedCard.new])
        expect{sheriff.target_of_bang(BangCard.new, outlaw_1)}.to change{sheriff.health}.by(-1)
      end
    end
  end

  describe "#discard" do
    let(:card_1) { Card.new }
    let(:card_2) { Card.new }
    it "removes the card from in play" do
      sheriff.in_play << card_1
      expect{sheriff.discard(card_1)}.to change{sheriff.in_play}.from([card_1]).to([])
    end
    it "removes the card from hand" do
      sheriff.hand << card_1
      expect{sheriff.discard(card_1)}.to change{sheriff.hand}.from([card_1]).to([])
    end
    it "does not remove a card of the same type" do
      sheriff.in_play << card_1
      sheriff.in_play << card_2
      expect{sheriff.discard(card_1)}.to change{sheriff.in_play}.from([card_1, card_2]).to([card_2])
    end
    it "adds the card to the top of the discard stack" do
      sheriff.in_play << card_1
      expect{sheriff.discard(card_1)}.to change{deck.discard}.from([]).to([card_1])
    end
  end

  describe "equip" do
    context "for non-guns" do
      let(:barrel_card_1) { BarrelCard.new }
      let(:barrel_card_2) { BarrelCard.new "suit", "number" }
      before do
        allow(sheriff).to receive(:discard).and_call_original
        sheriff.equip(barrel_card_1)
      end
      it 'moves the card into play' do
        expect(sheriff.in_play).to include(barrel_card_1)
      end
      it 'removes the card from hand' do
        expect(sheriff.hand).not_to include(barrel_card_1)
      end
      it 'raises an error on duplicate cards' do
        expect{ sheriff.equip(barrel_card_2) }.to raise_error
      end
    end
    context "for guns" do
      let(:schofield_card) { SchofieldCard.new }
      let(:rev_carbine_card) { RevCarbineCard.new }
      before do
        allow(sheriff).to receive(:discard).and_call_original
        sheriff.equip(schofield_card)
        sheriff.equip(rev_carbine_card)
      end
      it 'moves the second gun into play' do
        expect(sheriff.in_play).to include(rev_carbine_card)
      end
      it 'removes the second gun from hand' do
        expect(sheriff.hand).not_to include(rev_carbine_card)
      end
      it 'discards the first gun' do
        expect(sheriff).to have_received(:discard).with(schofield_card)
      end
    end
  end
end
