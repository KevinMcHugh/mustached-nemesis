require 'spec_helper'

describe TapBadge do
  class TapBadgeDummy
    include TapBadge
    def event_listener; end
  end

  let(:adverb) {'quickly'}
  let(:sheriff) { true }
  subject { TapBadgeDummy.new }
  before  { allow(subject).to receive(:sheriff?).and_return(sheriff) }

  it 'returns a new Event' do
    expect(TapBadge::Event).to receive(:new).with(nil, subject, adverb)
    subject.tap_badge(adverb)
  end
  context 'for the sheriff' do
    it 'returns an embarassing message' do
      expect(subject.tap_badge.to_s).to include('taps its badge')
    end
  end
  context 'for non-sheriffs' do
    let(:sheriff) { false }
    it 'returns an embarassing message' do
      expect(subject.tap_badge.to_s).to include('makes a fool')
    end
  end
  describe '#voluntary?' do
    it 'is true' do
      expect(subject.tap_badge.voluntary?).to be(true)
    end
  end
end
