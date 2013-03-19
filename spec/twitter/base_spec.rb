require 'helper'

describe Twitter::Base do

  context "identity map enabled" do
    before do
      Twitter.identity_map = Twitter::IdentityMap
      object = Twitter::Base.new(:id => 1)
      @base = Twitter::Base.store(object)
    end

    after do
      Twitter.identity_map = false
    end

    describe ".identity_map" do
      it "returns an instance of the identity map" do
        expect(Twitter::Base.identity_map).to be_a Twitter::IdentityMap
      end
    end

    describe ".fetch" do
      it "returns existing objects" do
        expect(Twitter::Base.fetch(:id => 1)).to be
      end

      it "raises an error on objects that don't exist" do
        expect{Twitter::Base.fetch(:id => 6)}.to raise_error Twitter::Error::IdentityMapKeyError
      end
    end

    describe ".store" do
      it "stores Twitter::Base objects" do
        object = Twitter::Base.new(:id => 4)
        expect(Twitter::Base.store(object)).to be_a Twitter::Base
      end
    end

    describe ".fetch_or_new" do
      it "returns existing objects" do
        expect(Twitter::Base.fetch_or_new(:id => 1)).to be
      end
      it "creates new objects and stores them" do
        expect(Twitter::Base.fetch_or_new(:id => 2)).to be
        expect(Twitter::Base.fetch(:id => 2)).to be
      end
    end

    describe "#[]" do
      it "calls methods using [] with symbol" do
        expect(@base[:object_id]).to be_an Integer
      end
      it "calls methods using [] with string" do
        expect(@base['object_id']).to be_an Integer
      end
      it "returns nil for missing method" do
        expect(@base[:foo]).to be_nil
        expect(@base['foo']).to be_nil
      end
    end

    describe "#to_hash" do
      it "returns a hash" do
        expect(@base.to_hash).to be_a Hash
        expect(@base.to_hash[:id]).to eq 1
      end
    end

    describe "identical objects" do
      it "have the same object_id" do
        expect(@base.object_id).to eq Twitter::Base.fetch(:id => 1).object_id
      end
    end

  end

  context "identity map disabled" do
    before(:all) do
      Twitter.identity_map = false
    end
    after(:all) do
      Twitter.identity_map = Twitter::IdentityMap
    end

    describe ".identity_map" do
      it "returns nil" do
        expect(Twitter::Base.identity_map).to be_nil
      end
    end

    describe ".fetch" do
      it "returns nil" do
        expect(Twitter::Base.fetch(:id => 1)).to be_nil
      end
    end

    describe ".store" do
      it "returns an instance of the object" do
        expect(Twitter::Base.store(Twitter::Base.new(:id => 1))).to be_a Twitter::Base
      end
    end

    describe ".fetch_or_new" do
      it "creates new objects" do
        expect(Twitter::Base.fetch_or_new(:id => 2)).to be
        expect(Twitter.identity_map).to be_false
      end
    end
  end

  describe '#attrs' do
    it 'returns a hash of attributes' do
      expect(Twitter::Base.new(:id => 1).attrs).to eq({:id => 1})
    end
  end

end
