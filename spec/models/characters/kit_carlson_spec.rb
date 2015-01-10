require 'spec_helper'
require 'card'
describe Character::KitCarlsonPlayer do
  let(:brain)  { double('brain', pick: [card1, card2]) }
  let(:player) { described_class.new(nil, deck, brain) }
  let(:deck)   { double('deck') }
  let(:card1)  { double('card1') }
  let(:card2)  { double('card2') }
  let(:card3)  { double('card3') }

  subject { player.draw_for_turn }
  describe '#draw_for_turn' do
    it 'takes 3 cards, keeps 2' do
      expect(deck).to receive(:take).and_return([card1, card2, card3])
      expect(deck).to receive(:draw).and_return([])
      expect{subject}.not_to raise_error
      expect(player.hand).to match_array([card1, card2])
    end
  end
end