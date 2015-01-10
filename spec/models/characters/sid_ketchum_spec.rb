require 'spec_helper'
require 'card'
describe Character::SidKetchumPlayer do
  let(:deck) { double('deck', discard: []) }
  let(:brain) { double('brain')}
  let(:player) { described_class.new(nil, deck, brain)}
  let(:card1)  { BangCard.new }
  let(:card2)  { StageCoachCard.new }
  describe '#play_as_beer' do
    subject { player.play_as_beer(card1, card2)}
    before { player.hit! }
    context 'with both played cards in hand' do
      before do
        player.give_card(card1)
        player.give_card(card2)
      end
      it 'heals one wound' do
        expect{subject}.to change{player.health}.by(1)
      end
      it 'discards both cards' do
        subject
        expect(player.hand).not_to include(card1)
        expect(player.hand).not_to include(card2)
      end
    end
    context 'with only one played card in hand' do
      before do
        player.give_card(card1)
      end
      it 'does not heal' do
        expect{subject}.not_to change{player.health}
      end
      it 'does not discards the card in hand' do
        subject
        expect(player.hand).to include(card1)
      end
    end
  end
  describe '#beer' do
    subject { player.beer }
    context 'with a beer card' do
      let(:beer_card) { BeerCard.new }
      before do
        player.left = double('player2', left: double('player3', left: player))
        player.give_card(beer_card)
      end
      it 'discards the beer card' do
        expect(subject).to be(true)
        expect(player.hand).not_to include(beer_card)
      end
    end
    context 'without a beer card' do
      before do
        allow(brain).to receive(:discard).and_return(card1, card2)
      end
      it 'asks the brain to discard' do
        expect(brain).to receive(:discard).exactly(2).times
        subject
      end
      before { player.give_card(card1) }
      context 'with the cards in hand' do
        before { player.give_card(card2) }
        it 'discards the chosen cards' do
          expect(subject).to be(true)
          expect(player.hand).not_to include(card1)
          expect(player.hand).not_to include(card2)
        end
      end
      context 'without the cards' do
        it 'does not discard the cards' do
          expect(subject).to be false
          expect(player.hand).to include(card1)
        end
      end
    end
  end
end