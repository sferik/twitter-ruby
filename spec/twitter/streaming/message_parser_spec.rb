require "helper"

describe X::Streaming::MessageParser do
  subject do
    described_class
  end

  describe ".parse" do
    it "returns a tweet if the data has an id" do
      data = {id: 1}
      object = subject.parse(data)
      expect(object).to be_a X::Tweet
      expect(object.id).to eq(1)
    end

    it "returns an event if the data has an event" do
      data = {event: "favorite", source: {id: 1}, target: {id: 2}, target_object: {id: 1}}
      object = subject.parse(data)
      expect(object).to be_a X::Streaming::Event
      expect(object.name).to eq(:favorite)
      expect(object.source).to be_a X::User
      expect(object.source.id).to eq(1)
      expect(object.target).to be_a X::User
      expect(object.target.id).to eq(2)
      expect(object.target_object).to be_a X::Tweet
      expect(object.target_object.id).to eq(1)
    end

    it "returns a direct message if the data has a direct_message" do
      data = {direct_message: {id: 1}}
      object = subject.parse(data)
      expect(object).to be_a X::DirectMessage
      expect(object.id).to eq(1)
    end

    it "returns a friend list if the data has friends" do
      data = {friends: [1]}
      object = subject.parse(data)
      expect(object).to be_a X::Streaming::FriendList
      expect(object.first).to eq(1)
    end

    it "returns a deleted tweet if the data has a deleted status" do
      data = {delete: {status: {id: 1}}}
      object = subject.parse(data)
      expect(object).to be_a X::Streaming::DeletedTweet
      expect(object.id).to eq(1)
    end

    it "returns a stall warning if the data has a warning" do
      data = {warning: {code: "FALLING_BEHIND"}}
      object = subject.parse(data)
      expect(object).to be_a X::Streaming::StallWarning
      expect(object.code).to eq("FALLING_BEHIND")
    end
  end
end
