require 'spec_helper'

describe CreateGame do

  subject { CreateGame.new(brains: [ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain], persist: persist).execute }

  let(:persist) { true }
  let(:game) {double('Game', round: 5, winners: [], events: [])}
  before do
    allow(Game).to receive(:new).and_return(game)
    allow(game).to receive(:start)
  end
  it 'does not fail' do
    expect(Game).to receive(:new).and_return(game)
    expect(game).to receive(:start)
    expect{subject}.to_not raise_error
  end

  context 'persist: true' do
    it 'creates a new GameRecord' do
      expect{subject}.to change{GameRecord.count}
      expect(GameRecord.first.rounds).to eql(5)
    end
  end
  context 'persist: false' do
    let(:persist) { false }
    it 'does not create a new GameRecord' do
      expect{subject}.to_not raise_error
    end
  end
end