require 'helper'

describe Twitter::Base do

  context 'identity map enabled' do
    before do
      object = Twitter::Base.new(:id => 1)
      @base = Twitter::Base.store(object)
    end

    describe "#[]" do
      it "calls methods using [] with symbol" do
        @base[:object_id].should be_an Integer
      end
      it "calls methods using [] with string" do
        @base['object_id'].should be_an Integer
      end
      it "returns nil for missing method" do
        @base[:foo].should be_nil
        @base['foo'].should be_nil
      end
    end

    describe "#to_hash" do
      it "returns a hash" do
        @base.to_hash.should be_a Hash
        @base.to_hash[:id].should eq 1
      end
    end

    describe "identical objects" do
      it "have the same object_id" do
        @base.object_id.should eq Twitter::Base.fetch(:id => 1).object_id
      end
    end

    describe '.fetch' do
      it 'returns existing objects' do
        Twitter::Base.fetch(:id => 1).should be
      end

      it "raises an error on objects that don't exist" do
        lambda {
          Twitter::Base.fetch(:id => 6)
        }.should raise_error(Twitter::IdentityMapKeyError)
      end
    end

    describe '.store' do
      it 'stores Twitter::Base objects' do
        object = Twitter::Base.new(:id => 4)
        Twitter::Base.store(object).should be_a Twitter::Base
      end
    end

    describe '.fetch_or_new' do
      it 'returns existing objects' do
        Twitter::Base.fetch_or_new(:id => 1).should be
      end

      it 'creates new objects and stores them' do
        Twitter::Base.fetch_or_new(:id => 2).should be

        Twitter::Base.fetch(:id => 2).should be
      end
    end
  end

  context 'identity map disabled' do
    before(:all) do
      Twitter.identity_map = false
    end
    after(:all) do
      Twitter.identity_map = Twitter::IdentityMap.new
    end

    describe '.fetch' do
      it 'returns nil' do
        Twitter::Base.fetch(:id => 1).should be_nil
      end
    end

    describe '.store' do
      it 'returns an instance of the object' do
        Twitter::Base.store(Twitter::Base.new(:id => 1)).should be_a Twitter::Base
      end
    end

    describe '.fetch_or_new' do
      it 'creates new objects' do
        Twitter::Base.fetch_or_new(:id => 2).should be
        Twitter.identity_map.should be_false
      end
    end
  end
end
