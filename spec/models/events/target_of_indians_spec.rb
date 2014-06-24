require 'spec_helper'

describe TargetOfIndians do
  describe '#target_of_indians' do
    class TargetOfIndiansDummy
      include TargetOfIndians
      def initialize(brain)
        @brain = brain
      end
      attr_reader :brain
      def event_listener; end
      def from_hand_dto_to_card(card_dto); end
      def discard(card); end
      def hit!(targetter); end
    end
    let(:brain) { double("brain", {target_of_indians: nil})}
    let(:targetter) { double("targetter", {target_of_indians: nil})}
    subject {TargetOfIndiansDummy.new(brain)}

    before do
      allow(subject).to receive(:can_play?).and_return(true)
    end
    it 'creates a new Event' do
      expect(TargetOfIndians::Event).to receive(:new)
      subject.target_of_indians(nil, targetter)
    end

    context 'when the brain gives a valid response' do
      it 'discards the response' do
        expect(subject).to receive(:discard).with(nil)
        subject.target_of_indians(nil, targetter)
      end
    end
    context 'when the brain doesnt give a valid response' do
      before do
        allow(subject).to receive(:can_play?).and_return(false)
      end
      it 'discards the response' do
        expect(subject).to receive(:hit!).with(targetter)
        subject.target_of_indians(nil, targetter)
      end
    end
  end
end
