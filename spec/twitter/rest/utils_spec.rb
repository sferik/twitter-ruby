require "helper"

describe "Twitter::REST::Utils helper behavior" do
  let(:client_class) do
    Class.new do
      include Twitter::REST::Utils

      attr_accessor :credentials_id

      def verify_credentials(skip_status:)
        raise ArgumentError, "skip_status must be true" unless skip_status

        Struct.new(:id).new(credentials_id)
      end
    end
  end

  let(:client) do
    client_class.new.tap do |instance|
      instance.credentials_id = 4242
    end
  end

  describe "#extract_id" do
    it "extracts IDs from each supported input type" do
      identity = Twitter::Identity.new(id: 99)
      uri = URI.parse("https://twitter.com/sferik/123")
      addressable_uri = Addressable::URI.parse("https://twitter.com/sferik/456")

      expect(client.send(:extract_id, 1)).to eq(1)
      expect(client.send(:extract_id, "https://twitter.com/sferik/2")).to eq(2)
      expect(client.send(:extract_id, uri)).to eq(123)
      expect(client.send(:extract_id, addressable_uri)).to eq(456)
      expect(client.send(:extract_id, identity)).to eq(99)
    end

    it "returns nil for unsupported input types" do
      expect(client.send(:extract_id, Object.new)).to be_nil
    end
  end

  describe "#perform_get" do
    it "delegates to perform_request with default empty options" do
      expect(client).to receive(:perform_request).with(:get, "/path", {}).and_return(:ok)

      expect(client.send(:perform_get, "/path")).to eq(:ok)
    end
  end

  describe "#perform_post" do
    it "delegates to perform_request with default empty options" do
      expect(client).to receive(:perform_request).with(:post, "/path", {}).and_return(:ok)

      expect(client.send(:perform_post, "/path")).to eq(:ok)
    end
  end

  describe "#perform_get_with_cursor" do
    it "uses merge_default_cursor! when no_default_cursor is false" do
      options = {no_default_cursor: false}
      request = instance_double(Twitter::REST::Request)

      expect(client).to receive(:merge_default_cursor!).with(options)
      expect(Twitter::REST::Request).to receive(:new).with(client, :get, "/path", options).and_return(request)
      expect(Twitter::Cursor).to receive(:new).with(:friends, nil, request, nil).and_return(:cursor)

      expect(client.send(:perform_get_with_cursor, "/path", options, :friends)).to eq(:cursor)
    end

    it "removes no_default_cursor and passes limit explicitly to Cursor" do
      options = {no_default_cursor: true, limit: 10}
      request = instance_double(Twitter::REST::Request)

      expect(client).not_to receive(:merge_default_cursor!)
      expect(Twitter::REST::Request).to receive(:new).with(client, :get, "/path", {}).and_return(request)
      expect(Twitter::Cursor).to receive(:new).with(:friends, nil, request, 10).and_return(:cursor)

      expect(client.send(:perform_get_with_cursor, "/path", options, :friends)).to eq(:cursor)
      expect(options).to eq({})
    end
  end

  describe "#users_from_response" do
    it "falls back to the current user_id when no user_id/screen_name option is present" do
      allow(client).to receive(:user_id).and_return(55)
      expect(client).to receive(:perform_request_with_objects).with(:get, "/users", {user_id: 55}, Twitter::User).and_return([])

      expect(client.send(:users_from_response, :get, "/users", [])).to eq([])
    end

    it "does not inject user_id when screen_name is already provided" do
      options = {screen_name: "sferik"}
      expect(client).not_to receive(:user_id)
      expect(client).to receive(:perform_request_with_objects).with(:get, "/users", options, Twitter::User).and_return([])

      client.send(:users_from_response, :get, "/users", [options])
    end

    it "does not inject user_id when user_id is already provided" do
      options = {user_id: 11}
      expect(client).not_to receive(:user_id)
      expect(client).to receive(:perform_request_with_objects).with(:get, "/users", options, Twitter::User).and_return([])

      client.send(:users_from_response, :get, "/users", [options])
    end
  end

  describe "#cursor_from_response_with_user" do
    it "injects current user_id when neither user_id nor screen_name is provided" do
      allow(client).to receive(:user_id).and_return(77)
      expect(client).to receive(:perform_get_with_cursor).with("/followers", {user_id: 77}, :users, Twitter::User).and_return(:cursor)

      expect(client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [])).to eq(:cursor)
    end

    it "keeps explicit screen_name untouched" do
      options = {screen_name: "sferik"}
      expect(client).not_to receive(:user_id)
      expect(client).to receive(:perform_get_with_cursor).with("/followers", options, :users, Twitter::User).and_return(:cursor)

      expect(client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [options])).to eq(:cursor)
    end
  end

  describe "#user_id?" do
    it "is false until user_id is memoized and true afterwards" do
      expect(client.send(:user_id?)).to be(false)

      client.send(:user_id)

      expect(client.send(:user_id?)).to be(true)
    end
  end

  describe "#merge_default_cursor!" do
    it "assigns the default cursor when cursor is nil" do
      options = {cursor: nil}
      client.send(:merge_default_cursor!, options)

      expect(options[:cursor]).to eq(Twitter::REST::Utils::DEFAULT_CURSOR)
    end
  end

  describe "#merge_user" do
    it "returns a new hash and keeps the original unchanged" do
      original = {trim_user: true}

      result = client.send(:merge_user, original, 123)

      expect(result).to eq(trim_user: true, user_id: 123)
      expect(original).to eq(trim_user: true)
    end

    it "respects an explicit prefix" do
      result = client.send(:merge_user, {}, 123, "target")

      expect(result).to eq(target_user_id: 123)
    end
  end

  describe "#merge_user!" do
    it "extracts screen_name from URI-like inputs" do
      hash = {}
      client.send(:merge_user!, hash, URI.parse("https://twitter.com/sferik"))

      expect(hash).to eq(screen_name: "sferik")
    end
  end

  describe "#set_compound_key" do
    it "uses a nil prefix by default" do
      hash = {}

      expect(client.send(:set_compound_key, "screen_name", "sferik", hash)).to eq(screen_name: "sferik")
    end
  end

  describe "#merge_users" do
    it "returns a copy and does not mutate the input hash" do
      original = {trim_user: true}

      result = client.send(:merge_users, original, [1, "sferik"])

      expect(original).to eq(trim_user: true)
      expect(result).to eq(trim_user: true, user_id: "1", screen_name: "sferik")
    end
  end

  describe "#merge_users!" do
    it "deduplicates users before collecting IDs and screen_names" do
      hash = {}
      users = [1, 1, "sferik", "sferik"]

      client.send(:merge_users!, hash, users)

      expect(hash[:user_id]).to eq("1")
      expect(hash[:screen_name]).to eq("sferik")
    end
  end

  describe "#collect_users" do
    it "collects IDs and screen names from all supported types" do
      users = [
        1,
        Twitter::User.new(id: 2),
        "sferik",
        URI.parse("https://twitter.com/erik"),
        Addressable::URI.parse("https://twitter.com/alice"),
      ]

      user_ids, screen_names = client.send(:collect_users, users)
      expect(user_ids).to eq([1, 2])
      expect(screen_names).to eq(%w[sferik erik alice])
    end

    it "ignores unsupported user-like objects" do
      users = [1, Object.new, "sferik"]

      user_ids, screen_names = client.send(:collect_users, users)
      expect(user_ids).to eq([1])
      expect(screen_names).to eq(["sferik"])
    end
  end
end
