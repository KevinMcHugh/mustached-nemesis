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
