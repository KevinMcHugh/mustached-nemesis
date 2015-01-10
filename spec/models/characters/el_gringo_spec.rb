require 'spec_helper'
require 'card'
describe Character::ElGringoPlayer do
  let(:player) { described_class.new(nil, deck, nil)}
  let(:deck) { double('deck', discard: []) }
  let(:card) { double('card') }
  let(:other_player) { double('player2', left: player, hand: [card]) }
  before  { player.left = other_player }

  subject { player.hit!(other_player) }
  describe "#hit!" do
    it 'takes a card from the hand of the hitter' do
      expect(other_player).to receive(:random_from_hand).and_return(card)
      expect{subject}.not_to raise_error
      expect(player.hand).to include(card)
      expect(other_player.hand).to be_empty
    end
  end
end