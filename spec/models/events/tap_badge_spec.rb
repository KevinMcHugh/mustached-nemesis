require 'spec_helper'

describe TapBadge do
  class Dummy
    include TapBadge
    def event_listener
    end
  end

  let(:adverb) {'quickly'}
  subject { Dummy.new }
  it 'returns a new Event' do
    expect(TapBadge::Event).to receive(:new).with(nil, subject, adverb)
    subject.tap_badge(adverb)
  end

  context 'for the sheriff' do
    before do
      allow(subject).to receive(:sheriff?).and_return(true)
    end
    it 'returns an embarassing message' do
      expect(subject.tap_badge.to_s).to include('taps its badge')
    end
  end
  context 'for non-sheriffs' do
    before do
      allow(subject).to receive(:sheriff?).and_return(false)
    end
    it 'returns an embarassing message' do
      expect(subject.tap_badge.to_s).to include('makes a fool')
    end
  end
end