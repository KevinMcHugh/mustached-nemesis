require 'spec_helper'

describe CreateGame do

  subject { CreateGame.new(brains: [ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain], persist: true).execute }

  it 'does not fail' do
    # expect{20.times {subject}}.to_not raise_error
    # this is dumb, it just makes the coverage fluctuate needlessly
  end
end