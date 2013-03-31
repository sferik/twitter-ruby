require 'helper'

describe Twitter::Stream::Response do

  describe ".new" do
    it "initializes an empty body" do
      expect(Twitter::Stream::Response.new.body).to eq('')
    end

    it "initializes with a body parameter" do
      expect(Twitter::Stream::Response.new('ohai').body).to eq('ohai')
    end
  end

  describe "#concat" do
    it "sets the body when empty" do
      response = Twitter::Stream::Response.new
      response.concat('{ "status" : true }')
      expect(response.body).to eq('{ "status" : true }')
    end

    it "appends to an existing body" do
      response = Twitter::Stream::Response.new('{ "status" : true')
      response.concat(', "enabled" : false }')
      expect(response.body).to eq('{ "status" : true, "enabled" : false }')
    end

    it "only appends when passed json" do
      str = '{ "status" : true'
      response = Twitter::Stream::Response.new(str)
      response.concat('ohai')
      expect(response.body).to eq(str)
    end

    it "passively fails on nil" do
      response = Twitter::Stream::Response.new
      expect {
        response.concat(nil)
      }.not_to raise_error
    end

    it "passively fails on empty strings" do
      response = Twitter::Stream::Response.new('ohai')
      response.concat('')
      expect(response.body).to eq('ohai')
    end

    it "passively fails on blank strings" do
      response = Twitter::Stream::Response.new('ohai')
      response.concat('  ')
      expect(response.body).to eq('ohai')
    end

    it "is aliased as <<" do
      response = Twitter::Stream::Response.new
      response << '{ "status" : true }'
      expect(response.body).to eq('{ "status" : true }')
    end

    it "updates the timestamp when data is received" do
      response = Twitter::Stream::Response.new
      response << '{ "status" : true }'
      expect(response.timestamp).to be_kind_of(Time)
    end
  end

  describe "#complete?" do
    it "returns false when an incomplete body" do
      expect(Twitter::Stream::Response.new('{ "status" : true').complete?).to be_false
    end

    it "returns false when an complete body" do
      expect(Twitter::Stream::Response.new('{ "status" : true }').complete?).to be_true
    end
  end

  describe "#older_than?" do
    it "returns false when the last response is younger than the number of seconds" do
      response = Twitter::Stream::Response.new
      expect(response.older_than?(100)).to be_false
    end

    it "returns true when the last response is older than the number of seconds" do
      response = Twitter::Stream::Response.new
      response.concat('fakebody')
      sleep(2)
      expect(response.older_than?(1)).to be_true
    end

    it "generates a timestamp when no initial timestamp exists" do
      response = Twitter::Stream::Response.new
      response.older_than?(100)
      expect(response.timestamp).to be_kind_of(Time)
    end
  end

  describe "#empty?" do
    it "returns true when an empty body" do
      expect(Twitter::Stream::Response.new).to be_empty
    end

    it "returns false when a body is present" do
      expect(Twitter::Stream::Response.new('{ "status" : true }')).not_to be_empty
    end
  end

  describe "#reset" do
    it "resets the body to an empty string" do
      response = Twitter::Stream::Response.new('{ "status" : true }')
      expect(response.body.length).to be > 0
      response.reset
      expect(response.body).to eq('')
    end
  end
end
