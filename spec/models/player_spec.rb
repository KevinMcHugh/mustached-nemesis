require 'spec_helper'

describe Player do
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
