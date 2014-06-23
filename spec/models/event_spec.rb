require 'spec_helper'
require 'card'
describe Event do
  class SubEvent < Event
    attr_reader :card, :player
    def initialize(card, player)
      @card = card
      @player = player
    end
  end

  let(:beer_card) { BeerCard.new }
  describe '#as_json' do
    let(:expected_card) {{:@type=>"BeerCard", :@number=>nil, :@suit=>nil}}
    subject {SubEvent.new(beer_card, Player)}

    it 'turns classes into strings' do
      expect(subject.as_json[:@player]).to eql('Player')
    end
    it 'calls as_json on other objects' do
      expect(subject.as_json[:@card]).to eql(expected_card)
    end
  end

  describe '#to_brainsafe' do
    let(:player) {Player.new "", nil }
    subject {SubEvent.new(beer_card, player)}
    it 'turns Players into PlayerDTOs' do
      expect(subject.to_brainsafe[:@player]).to eq(PlayerDTO.new(player))
    end
    it 'turns Cards into CardDTOs' do
      expect(subject.to_brainsafe[:@card]).to eql(beer_card.to_dto)
    end
  end
end
