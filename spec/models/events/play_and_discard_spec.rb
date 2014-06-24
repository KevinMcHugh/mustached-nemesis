require 'spec_helper'
require 'card'
describe PlayAndDiscard do
  describe '#play_and_discard' do
    class PlayAndDiscardDummy
      include PlayAndDiscard
      attr_reader :bangs_played
      def initialize
        @bangs_played = 0
      end
      def event_listener; end
      def over_bang_limit?; false; end
      def in_range?(card, target_player); true; end
      def discard(card, already_logged=false); end
    end
    subject {PlayAndDiscardDummy.new}
    let(:beer_card) {double("card", {play: nil, type: nil})}
    it 'creates a new Event' do
      expect(PlayAndDiscard::Event).to receive(:new)
      subject.play_and_discard(beer_card)
    end

    it 'calls play on the card' do
      expect(beer_card).to receive(:play)
      subject.play_and_discard(beer_card)
    end

    it 'discards the card' do
      expect(subject).to receive(:discard).with(beer_card, true)
      subject.play_and_discard(beer_card)
    end

    context 'for a bang card' do
      let(:bang_card) {BangCard.new}
      let(:bang_target) { double("target", {target_of_bang: nil})}
      it 'increments the bangs_played counter' do
        expect { subject.play_and_discard(bang_card, bang_target) }.to change {
          subject.bangs_played}.by(1)
      end
      it 'throws an error if too many bangs have been played' do
        subject.play_and_discard(bang_card, bang_target)
        allow(subject).to receive(:over_bang_limit?).and_return(true)
        expect{subject.play_and_discard(bang_card, bang_target)}.to raise_error
      end
    end

    context 'for a card that is out of range' do
      before do
        allow(subject).to receive(:in_range?).and_return(false)
      end
      it 'raises an exception' do
        expect {subject.play_and_discard(beer_card)}.to raise_error
      end
    end
  end
end
