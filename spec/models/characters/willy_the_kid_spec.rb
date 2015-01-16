require 'spec_helper'
require 'card'
describe Character::WillyTheKidPlayer do
  let(:player) { described_class.new(nil, deck, nil)}
  let(:card) { BangCard.new }
  let(:deck) { double('deck', discard: [])}
  let(:other_player) { double('player2', left: player, range_increase: 0) }
  before  { player.left = other_player }

  describe '#over_bang_limit?' do
    subject { player.over_bang_limit? }
    it 'is always true' do
      allow(other_player).to receive(:distance_to).and_return(0)
      expect(other_player).to receive(:target_of_bang).exactly(5).times
      5.times { player.play_and_discard(card, other_player)}
      expect(subject).to be(false)
    end
  end
end
