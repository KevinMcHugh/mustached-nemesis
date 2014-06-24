require 'spec_helper'

describe PlayAndDiscard::Event do
  context '#to_s' do
    context '#to_s' do
      context 'an untargetted card' do
        let(:player) { Player.new '', nil }
        let(:bang_card) { BangCard.new }
        subject { described_class.new(nil, player, bang_card, nil, nil) }
        it 'does not mention targets' do
          expect(subject.to_s).to eql('Player playing and discarding BangCard')
        end
      end
      context 'a card targetted at a player' do
        let(:player) { Player.new '', nil }
        let(:target_player) { Player.new '', nil }
        let(:bang_card) { BangCard.new }
        subject { described_class.new(nil, player, bang_card, target_player, nil) }
        it 'does not mention targets' do
          expect(subject.to_s).to eql('Player playing and discarding BangCard at Player')
        end
      end
      context 'a card targetted at the card of a player' do
        let(:player) { Player.new '', nil }
        let(:target_player) { Player.new '', nil }
        let(:cat_balou) { CatBalouCard.new }
        subject { described_class.new(nil, player, cat_balou, target_player, Card.barrel_card) }
        it 'does not mention targets' do
          expect(subject.to_s).to eql("Player playing and discarding CatBalouCard at Player's BarrelCard")
        end
      end
      context 'a card targetted at the hand of a player' do
        let(:player) { Player.new '', nil }
        let(:target_player) { Player.new '', nil }
        let(:cat_balou) { CatBalouCard.new }
        subject { described_class.new(nil, player, cat_balou, target_player, :hand) }
        it 'does not mention targets' do
          expect(subject.to_s).to eql("Player playing and discarding CatBalouCard at Player's hand")
        end
      end
    end
  end
end
