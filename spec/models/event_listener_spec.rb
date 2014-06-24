require 'spec_helper'

describe EventListener do
  subject { described_class.new(nil) }
  class Subscriber
    def notify(event); end
  end
  let(:subscriber) { Subscriber.new }
  describe '#subscribe' do
    let(:event) { double("event", {:player_killed? => false, :game_over? => false})}

    before do
      subject.subscribe(subscriber)
    end
    it 'notifies subscribers on events' do
      expect(subscriber).to receive(:notify).with(event)
      subject.notify(event)
    end
  end

  describe '#notify' do
    context 'for a player killed event' do
      let(:event) do
        double("event", {:player_killed? => true, :game_over? => false, :sheriff_killed? => false})
      end
      it 'checks if the game was over' do
        expect(event).to receive(:sheriff_killed?)
        expect(subject).to receive(:sheriff_win?)
        subject.notify(event)
      end
      context 'when the game is over' do
        it 'creates a new GameOverEvent' do
          expect(subject).to receive(:sheriff_win?).and_return(true)
          expect(GameOverEvent).to receive(:new)
          subject.notify(event)
        end
      end
      context 'when the game is not over' do
        it 'does not create a new GameOverEvent' do
          expect(subject).to receive(:sheriff_win?)
          expect(GameOverEvent).to_not receive(:new)
          subject.notify(event)
        end
      end
    end
  end

  describe '#sheriff_win?' do
    let(:sheriff) {Player.new('sheriff', nil)}
    subject { described_class.new(game) }
    context 'when the sheriff has won' do
      let(:game) { Game.new([sheriff], nil)}
      it 'returns true' do
        expect(subject.sheriff_win?).to be(true)
      end
    end
    context 'when the sheriff has not won' do
      let(:outlaw) { Player.new('outlaw', nil)}
      let(:game) {Game.new([sheriff, outlaw], nil)}
      it 'returns false' do
        expect(subject.sheriff_win?).to be(false)
      end
    end
  end
end
