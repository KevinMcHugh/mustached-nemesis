require 'spec_helper'
require 'card'
describe NewTurnStarted::Event do
  let(:event_listener) { EventListener.new(nil) }
  let(:player) { Player.new("sheriff", nil)}
  let(:hand) { ["BangCard"] }
  let(:in_play) { ["BarrelCard"] }

  subject { described_class.new(event_listener, player)}
  before do
    player.hand << BangCard.new
    player.in_play << BarrelCard.new
  end
  describe "#to_s" do
    it 'returns a string with the cards in play' do
      expect(subject.to_s).to include("In play: #{in_play}")
    end
    it 'returns a string with the cards in hand' do
      expect(subject.to_s).to include("In hand: #{hand}")
    end
    it 'returns a string with the player as a string' do
      expect(subject.to_s).to include('Player|5|sheriff|PlayerBrain::Brain')
    end
  end

  describe '#as_json' do
    it 'returns the player' do
      expect(subject.as_json[:@player]).to eql({:@name => "Player"})
    end
    it 'returns the type of the event' do
      expect(subject.as_json[:@type]).to eql(described_class.to_s)
    end
    it 'returns the cards in hand' do
      expect(subject.as_json[:@hand]).to eql(hand)
    end
    it 'returns the cards in play' do
      expect(subject.as_json[:@in_play]).to eql(in_play)
    end
  end
end
