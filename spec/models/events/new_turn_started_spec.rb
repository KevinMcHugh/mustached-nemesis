require 'spec_helper'

describe NewTurnStarted do
  describe '#new_turn_started' do
    class NewTurnStartedDummy
      include NewTurnStarted
      def event_listener; end
    end
    subject {NewTurnStartedDummy.new}
    it 'creates a new Event' do
      expect(NewTurnStarted::Event).to receive(:new)
      subject.new_turn_started
    end
  end
end
