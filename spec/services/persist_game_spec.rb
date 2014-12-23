require 'spec_helper'

describe PersistGame do

  describe '#execute' do
    let(:player) { double('player', character: 'p')}
    let(:target) { double('target', character: 't')}
    let(:event) { double('event', player: player, target: target)}
    let(:game) { double('game', events: [event], round: 0, winners: [player])}
    let(:p_brain) { double('brain', player: player, role: 'p')}
    let(:t_brain) { double('brain', player: target, role: 't')}

    subject {described_class.new(game: game, brains: [p_brain, t_brain]).execute }
    it 'creates new PlayerRecords' do
      expect{subject}.to change{PlayerRecord.count}.by(2)
      expect(PlayerRecord.first.role).to eql('p')
      expect(PlayerRecord.all.second.role).to eql('t')
    end

    it 'creates new EventRecords' do
      expect{subject}.to change{EventRecord.count}.by(1)
      expect(EventRecord.first.player_record).to eq(PlayerRecord.first)
      expect(EventRecord.first.target_player_record).to eq(PlayerRecord.all.second)
    end

    it 'creates a new GameRecord' do
      expect{subject}.to change{GameRecord.count}.by(1)
    end
  end
end