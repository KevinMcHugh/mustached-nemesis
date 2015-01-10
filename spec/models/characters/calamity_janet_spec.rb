require 'spec_helper'
require 'card'
describe Character::CalamityJanetPlayer do
  let(:player) { described_class.new(nil, deck, nil)}
  let(:deck) { double('deck', discard: []) }
  let(:target) { double('player2', left: player, range_increase: 0) }
  before  { player.left = target }
  describe '#play_and_discard' do
    let(:missed_card) { MissedCard.new }
    subject { player.play_and_discard(missed_card, target) }
    before { allow(target).to receive(:target_of_bang) }
    it 'interprets a missed as a bang' do
      expect(target).to receive(:target_of_bang)
      subject
      expect(player.instance_variable_get(:@bangs_played)).to be(1)
    end
    it 'discards the MissedCard' do
      subject
      expect(player.hand).not_to include(missed_card)
    end
  end
end