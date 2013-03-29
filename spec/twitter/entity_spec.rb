require 'helper'

describe Twitter::Entity do

  describe "#id_str" do
    it "returns the id_str of the Entity when set" do
      entity = Twitter::Entity.new(:id => 7505382, :id_str => '7505382')
      expect(entity.id_str).to eq('7505382')
    end
    it "returns nil when not set" do
      entity = Twitter::Entity.new(:id => 7505382)
      expect(entity.id_str).to be_nil
    end
  end

end
