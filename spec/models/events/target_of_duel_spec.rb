require 'spec_helper'

describe TargetOfDuel do
  describe '#target_of_duel' do
    class TargetOfDuelDummy
      include TargetOfDuel
      def initialize(brain)
        @brain = brain
      end
      attr_reader :brain
      def event_listener; end
      def from_hand_dto_to_card(card_dto); end
      def discard(card); end
      def hit!(targetter); end
    end
    let(:brain) { double("brain", {target_of_duel: nil})}
    let(:targetter) { double("targetter", {target_of_duel: nil})}
    subject {TargetOfDuelDummy.new(brain)}

    before do
      allow(subject).to receive(:can_play?).and_return(true)
    end
    it 'creates a new Event' do
      expect(TargetOfDuel::Event).to receive(:new)
      subject.target_of_duel(nil, targetter)
    end

    context 'when the brain gives a valid response' do
      it 'discards the response' do
        expect(subject).to receive(:discard).with(nil)
        subject.target_of_duel(nil, targetter)
      end
    end
    context 'when the brain doesnt give a valid response' do
      before do
        allow(subject).to receive(:can_play?).and_return(false)
      end
      it 'discards the response' do
        expect(subject).to receive(:hit!).with(targetter)
        subject.target_of_duel(nil, targetter)
      end
    end
  end
end
