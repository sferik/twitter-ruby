require "test_helper"

describe Twitter::Streaming::MessageParser do
  let(:message_parser) { Twitter::Streaming::MessageParser }

  describe ".parse" do
    it "returns a tweet if the data has an id" do
      data = {id: 1}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::Tweet, object)
      assert_equal(1, object.id)
    end

    it "returns an event if the data has an event" do
      data = {event: "favorite", source: {id: 1}, target: {id: 2}, target_object: {id: 1}}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::Streaming::Event, object)
      assert_equal(:favorite, object.name)
      assert_kind_of(Twitter::User, object.source)
      assert_equal(1, object.source.id)
      assert_kind_of(Twitter::User, object.target)
      assert_equal(2, object.target.id)
      assert_kind_of(Twitter::Tweet, object.target_object)
      assert_equal(1, object.target_object.id)
    end

    it "returns a direct message if the data has a direct_message" do
      data = {direct_message: {id: 1}}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::DirectMessage, object)
      assert_equal(1, object.id)
    end

    it "returns a friend list if the data has friends" do
      data = {friends: [1]}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::Streaming::FriendList, object)
      assert_equal(1, object.first)
    end

    it "returns a deleted tweet if the data has a deleted status" do
      data = {delete: {status: {id: 1}}}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::Streaming::DeletedTweet, object)
      assert_equal(1, object.id)
    end

    it "returns nil if delete key exists but status key is missing" do
      data = {delete: {other_key: "value"}}
      object = message_parser.parse(data)

      assert_nil(object)
    end

    it "returns a stall warning if the data has a warning" do
      data = {warning: {code: "FALLING_BEHIND"}}
      object = message_parser.parse(data)

      assert_kind_of(Twitter::Streaming::StallWarning, object)
      assert_equal("FALLING_BEHIND", object.code)
    end

    it "returns nil for unrecognized data" do
      data = {unknown_key: "value"}
      object = message_parser.parse(data)

      assert_nil(object)
    end
  end
end
