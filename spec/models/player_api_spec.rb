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
      expect(subject.from_hand(Card.barrel_card)).to eql(barrel_card.to_dto)
    end
    it 'does not find a card in hand that is not in hand' do
      expect(subject.from_hand(Card.jail_card)).to eql(nil)
    end
  end
  context '#from_play' do
    it 'finds a card in play from the type specified' do
      expect(subject.from_play(Card.jail_card)).to eql(jail_card.to_dto)
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
  context '#play_card' do
    context 'a brown card' do
      let(:beer_card) { BeerCard.new }
      before do
        allow(player).to receive(:play_and_discard)
        player.hand << beer_card
        subject.play_card(beer_card.to_dto)
      end
      it 'calls to player' do
        expect(player).to have_received(:play_and_discard).with(beer_card, nil, nil)
      end
      it 'the card is no longer in the players hand' do
        expect(subject.hand).not_to include(beer_card)
      end
    end
    context 'a blue card' do
      before do
        subject.play_card(barrel_card.to_dto)
      end
      it 'puts the card in play' do
        expect(subject.in_play).to include(barrel_card.to_dto)
      end
      it 'removes the card from the hand' do
        expect(subject.hand).not_to include(barrel_card.to_dto)
      end
    end
    context 'any exception' do
      let(:dummy) { double("dummy", :equipment? => false, to_dto: {}) }
      before do
        player.hand << dummy
        allow(player).to receive(:play_and_discard).with(dummy, nil, nil).and_raise(OutOfRangeException)
      end
      it 'swallows the exception and discards the card' do
        expect(player).to receive(:discard).with(dummy)
        expect{subject.play_card(dummy.to_dto, nil, nil)}.not_to raise_error
      end
    end
  end
end
