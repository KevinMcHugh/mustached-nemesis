require 'spec_helper'

describe GameOverEvent do
  def kill(players)
    players.each do |player|
      5.times  { player.hit! }
    end
  rescue
  end
  let(:deck) { Deck.new(seed:Random.new) }
  let(:sheriff) { Player.new("sheriff", deck) }
  let(:outlaw_1) { Player.new("outlaw", deck) }
  let(:outlaw_2) { Player.new("outlaw", deck) }
  let(:renegade) { Player.new("renegade", deck) }
  let(:deputy) { Player.new("deputy", deck) }
  let(:players){ [sheriff, outlaw_1, outlaw_2, renegade, deputy] }

  subject {described_class.new(nil, game)}
  context 'sheriff win' do
    let(:game) do
      double("game", {living_players: [sheriff], round: 0, players: players})
    end
    it 'returns the sheriff & deputy' do
      expect(subject.winners).to match_array([sheriff, deputy])
    end
    it 'to_s works' do
      expect(subject.to_s).to eql('the forces of law have prevailed in 0 rounds!')
    end
  end
  context 'renegade win' do
    let(:game) { double("game", {living_players: [renegade], round: 0})}
    it 'returns the renegade' do
      expect(subject.winners).to match_array([renegade])
    end
    it 'to_s works' do
      expect(subject.to_s).to eql('the renegade has prevailed in 0 rounds!')
    end
  end
  context 'outlaw win' do
    let(:game) do
      double("game", {living_players: [outlaw_1], round: 0, players: players})
    end
    it 'returns the renegade' do
      expect(subject.winners).to match_array([outlaw_1, outlaw_2])
    end
    it 'to_s works' do
      expect(subject.to_s).to eql('the outlaws have prevailed in 0 rounds!')
    end
  end
  describe '#voluntary?' do
    let(:game) { double("game", {living_players: [renegade], round: 0})}
    it 'returns false' do
      expect(subject.voluntary?).to be(false)
    end
  end
end
