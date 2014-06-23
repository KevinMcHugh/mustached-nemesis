require 'spec_helper'

describe Heal do
  class Dummy
    attr_reader :health, :max_health
    include Heal
    def initialize
      @health = 0
      @max_health = 2
    end
  end

  subject { Dummy.new }
  it 'heals by one without an argument' do
    expect{subject.heal}.to change{subject.health}.by 1
  end

  it 'heals by the specified number of health' do
    expect{subject.heal(2)}.to change{subject.health}.by 2
  end

  it 'will not heal past max health' do
    expect{subject.heal(3)}.to change{subject.health}.by 2
  end

  it 'returns a new event' do
    expect(subject.heal.class).to eql(Heal::Event)
  end
end
