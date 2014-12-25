require 'spec_helper'

describe CreateGame do

  subject { CreateGame.new(brains: [ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain,
    ExampleBrains::MildlyIntelligentBrain], persist: true).execute }

  it 'does not fail' do
    expect{subject}.to_not raise_error
  end
end