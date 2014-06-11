require 'spec_helper'

describe Card do
  describe "#explode?" do
    it "should explode on 2 through 9 of spades" do
      7.times do |number|
        expect(Card.new("spade", number + 2).explode?).to eq true
      end
    end
    it "should not explde on a different suit" do
      expect(Card.new("heart", 5).explode?).to eq false
      expect(Card.new("diamond", 5).explode?).to eq false
      expect(Card.new("club", 5).explode?).to eq false
    end
    it "should not explode on 1 or above 9" do
      expect(Card.new("spade", 1).explode?).to eq false
      expect(Card.new("spade", 10).explode?).to eq false
    end
  end

  describe "#barrelable?" do
    it "should barrel bang!" do
      expect(BangCard.new.barrelable?).to eq true
    end
    it "should barrel punch" do
      expect(PunchCard.new.barrelable?).to eq true
    end
    it "should barrel springfield" do
      expect(SpringfieldCard.new.barrelable?).to eq true
    end
    it "should barrel gatling" do
      expect(GatlingCard.new.barrelable?).to eq true
    end
    it "should not barrel duel" do
      #expect(Card.new("spade", 1).barrelable?).to eq false
    end
    it "should not barrel indians" do
      #expect(Card.new("spade", 1).barrelable?).to eq false
    end
  end

  describe "#still_in_jail?" do
    it "should return flase on hearts" do
      expect(Card.new("heart", 1).still_in_jail?).to eq false
    end
    it "should return true on other suits" do
      expect(Card.new("spade", 1).still_in_jail?).to eq true
      expect(Card.new("club", 1).still_in_jail?).to eq true
      expect(Card.new("diamond", 1).still_in_jail?).to eq true
    end
  end

  describe "#type" do
    it "should match the type" do
      expect(BeerCard.new("spade", 1).type).to eq Card.beer_card
    end
  end

end