require 'spec_helper'
require 'card'
describe Character::JesseJonesPlayer do
  let(:player) { described_class.new(nil, deck, brain)}
  let(:brain) { double('brain') }
  let(:deck) { double('deck') }
  let(:card) { double('card') }
  let(:card2) { double('card2') }
  let(:other_player) { Player.new(nil, deck, nil) }
  before do
    player.left = other_player
    other_player.left = player
    other_player.hand << card
  end

  subject {player.draw_for_turn}

  describe '#draw_for_turn' do
    context 'when it picks to draw from hand' do
      it 'takes one card from deck, one from hand' do
        expect(deck).to receive(:take).and_return([card2])
        expect(player).to receive(:draw).and_call_original
        expect(brain).to receive(:draw_choice).with([nil, other_player]).
          and_return(other_player)
        subject
        expect(player.hand).to match_array([card, card2])
      end

      it 'the other player does not have the taken card' do
        allow(brain).to receive(:draw_choice).and_return(other_player)
        allow(deck).to receive(:take).and_return([card2])
        subject
        expect(other_player.hand).not_to include(card)
      end
    end
    context 'when it picks to draw from deck' do
      it 'draws twice from deck' do
        expect(brain).to receive(:draw_choice).and_return(nil)
        expect(deck).to receive(:take).twice.and_return([])
        subject
      end
    end
  end
end