require 'spec_helper'

describe PlayerAPI do
  let(:deck) { Deck.new }
  let(:player) { Player.new("sheriff", deck) }
  let(:brain) { double("brain") }
  let(:jail_card) { JailCard.new }
  let(:barrel_card) { BarrelCard.new }

  subject { described_class.new(player, brain)}
  before do
    player.in_play << jail_card
    player.hand << barrel_card
  end
  context '#from_hand' do
    it 'finds a card in hand from the type specified' do
      expect(subject.from_hand(Card.barrel_card)).to eql(barrel_card)
    end
    it 'does not find a card in hand that is not in hand' do
      expect(subject.from_hand(Card.jail_card)).to eql(nil)
    end
  end
  context '#from_play' do
    it 'finds a card in play from the type specified' do
      expect(subject.from_play(Card.jail_card)).to eql(jail_card)
    end
    it 'does not find a card in play that is not in play' do
      expect(subject.from_play(Card.barrel_card)).to eql(nil)
    end
  end
end
