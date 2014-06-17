require 'spec_helper'

describe PlayerAPI do
  let(:deck) { Deck.new }
  let(:player) { Player.new("sheriff", deck) }
  let(:other_player) { Player.new("renegade", deck) }
  let(:brain) { double("brain") }
  let(:jail_card) { JailCard.new }
  let(:barrel_card) { BarrelCard.new }

  subject { described_class.new(player, brain)}
  before do
    player.in_play << jail_card
    player.hand << barrel_card
    player.right = other_player
    other_player.right = player
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
  context '#instance_variable_get' do
    it 'is private' do
      expect{subject.instance_variable_get('fartzilla')}.to raise_exception
    end
  end
  context '#players' do
    it 'returns all other players in the game' do
      expect(subject.players.size).to eql(1)
    end
    it 'returns PlayerDTOs' do
      expect(subject.players.map(&:class).uniq).to eql([PlayerDTO])
    end
  end
  context '#health' do
    it 'returns the players health' do
      expect(subject.health).to eql(player.health)
    end
  end
  context '#character' do
    it 'returns the name of the players character' do
      expect(subject.character).to eql('Player')
    end
  end
end
