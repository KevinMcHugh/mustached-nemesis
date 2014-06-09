require 'spec_helper'

describe Player do
  let(:sheriff) { described_class.new("sheriff", nil) }
  let(:outlaw_1) { described_class.new("outlaw", nil) }
  let(:outlaw_2) { described_class.new("outlaw", nil) }
  let(:renegade) { described_class.new("renagade", nil) }
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
      subject { described_class.new("outlaw", nil) }
      it 'returns false' do
        expect(subject.sheriff?).to be_false
      end
    end
    context 'when the player is the sheriff' do
      subject { described_class.new("sheriff", nil) }
      it 'returns false' do
        expect(subject.sheriff?).to be_true
      end
    end
  end
end
