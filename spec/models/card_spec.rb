require 'spec_helper'

describe Card do
  describe "#explode?" do
    it "should explode on 2 through 9 of spades" do
      7.times do |number|
        expect(Card.new("spade", number + 2, "barrel").explode?).to eq true
      end
    end
    it "should not explde on a different suit" do
      expect(Card.new("heart", 5, "barrel").explode?).to eq false
      expect(Card.new("diamond", 5, "barrel").explode?).to eq false
      expect(Card.new("club", 5, "barrel").explode?).to eq false
    end
    it "should not explode on 1 or above 9" do
      expect(Card.new("spade", 1, "barrel").explode?).to eq false
      expect(Card.new("spade", 10, "barrel").explode?).to eq false
    end
  end

  describe "#barrelable?" do
    it "should barrel bang!" do
      expect(Card.new("spade", 1, "bang!").barrelable?).to eq true
    end
    it "should barrel punch" do
      expect(Card.new("spade", 1, "punch").barrelable?).to eq true
    end
    it "should barrel springfield" do
      expect(Card.new("spade", 1, "springfield").barrelable?).to eq true
    end
    it "should barrel gatling" do
      expect(Card.new("spade", 1, "gatling").barrelable?).to eq true
    end
    it "should not barrel duel" do
      expect(Card.new("spade", 1, "duel").barrelable?).to eq false
    end
    it "should not barrel indians" do
      expect(Card.new("spade", 1, "indians").barrelable?).to eq false
    end
  end

  describe "#still_in_jail?" do
    it "should return flase on hearts" do
      expect(Card.new("heart", 1, "indians").still_in_jail?).to eq false
    end
    it "should return true on other suits" do
      expect(Card.new("spade", 1, "indians").still_in_jail?).to eq true
      expect(Card.new("club", 1, "indians").still_in_jail?).to eq true
      expect(Card.new("diamond", 1, "indians").still_in_jail?).to eq true
    end
  end
end