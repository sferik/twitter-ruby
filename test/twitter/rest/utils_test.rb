require "test_helper"

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

      assert_equal(1, client.send(:extract_id, 1))
      assert_equal(2, client.send(:extract_id, "https://twitter.com/sferik/2"))
      assert_equal(123, client.send(:extract_id, uri))
      assert_equal(456, client.send(:extract_id, addressable_uri))
      assert_equal(99, client.send(:extract_id, identity))
    end

    it "returns nil for unsupported input types" do
      assert_nil(client.send(:extract_id, Object.new))
    end
  end

  describe "#perform_get" do
    it "delegates to perform_request with default empty options" do
      called = false

      client.stub(:perform_request, lambda { |verb, path, options|
        called = true

        assert_equal(:get, verb)
        assert_equal("/path", path)
        assert_empty(options)
        :ok
      }) do
        assert_equal(:ok, client.send(:perform_get, "/path"))
      end
      assert(called)
    end
  end

  describe "#perform_post" do
    it "delegates to perform_request with default empty options" do
      called = false

      client.stub(:perform_request, lambda { |verb, path, options|
        called = true

        assert_equal(:post, verb)
        assert_equal("/path", path)
        assert_empty(options)
        :ok
      }) do
        assert_equal(:ok, client.send(:perform_post, "/path"))
      end
      assert(called)
    end
  end

  describe "#perform_get_with_cursor" do
    it "uses merge_default_cursor! when no_default_cursor is false" do
      options = {no_default_cursor: false}
      request = Object.new
      merge_called = false
      request_new_called = false
      cursor_new_called = false

      client.stub(:merge_default_cursor!, lambda { |passed_options|
        merge_called = true

        assert_operator(passed_options, :equal?, options)
      }) do
        Twitter::REST::Request.stub(:new, lambda { |passed_client, verb, path, passed_options|
          request_new_called = true

          assert_operator(passed_client, :equal?, client)
          assert_equal(:get, verb)
          assert_equal("/path", path)
          assert_operator(passed_options, :equal?, options)
          request
        }) do
          Twitter::Cursor.stub(:new, lambda { |key, klass, passed_request, limit|
            cursor_new_called = true

            assert_equal(:friends, key)
            assert_nil(klass)
            assert_operator(passed_request, :equal?, request)
            assert_nil(limit)
            :cursor
          }) do
            assert_equal(:cursor, client.send(:perform_get_with_cursor, "/path", options, :friends))
          end
        end
      end

      assert(merge_called)
      assert(request_new_called)
      assert(cursor_new_called)
    end

    it "removes no_default_cursor and passes limit explicitly to Cursor" do
      options = {no_default_cursor: true, limit: 10}
      request = Object.new
      request_new_called = false
      cursor_new_called = false

      client.stub(:merge_default_cursor!, lambda {
        flunk("expected #merge_default_cursor! not to be called")
      }) do
        Twitter::REST::Request.stub(:new, lambda { |passed_client, verb, path, passed_options|
          request_new_called = true

          assert_operator(passed_client, :equal?, client)
          assert_equal(:get, verb)
          assert_equal("/path", path)
          assert_empty(passed_options)
          request
        }) do
          Twitter::Cursor.stub(:new, lambda { |key, klass, passed_request, limit|
            cursor_new_called = true

            assert_equal(:friends, key)
            assert_nil(klass)
            assert_operator(passed_request, :equal?, request)
            assert_equal(10, limit)
            :cursor
          }) do
            assert_equal(:cursor, client.send(:perform_get_with_cursor, "/path", options, :friends))
          end
        end
      end

      assert(request_new_called)
      assert(cursor_new_called)
      assert_empty(options)
    end
  end

  describe "#users_from_response" do
    it "falls back to the current user_id when no user_id/screen_name option is present" do
      perform_called = false
      client.stub(:user_id, 55) do
        client.stub(:perform_request_with_objects, lambda { |verb, path, options, klass|
          perform_called = true

          assert_equal(:get, verb)
          assert_equal("/users", path)
          assert_equal({user_id: 55}, options)
          assert_equal(Twitter::User, klass)
          []
        }) do
          assert_empty(client.send(:users_from_response, :get, "/users", []))
        end
      end

      assert(perform_called)
    end

    it "does not inject user_id when screen_name is already provided" do
      options = {screen_name: "sferik"}
      perform_called = false
      client.stub(:user_id, lambda {
        flunk("expected #user_id not to be called")
      }) do
        client.stub(:perform_request_with_objects, lambda { |verb, path, passed_options, klass|
          perform_called = true

          assert_equal(:get, verb)
          assert_equal("/users", path)
          assert_operator(passed_options, :equal?, options)
          assert_equal(Twitter::User, klass)
          []
        }) do
          client.send(:users_from_response, :get, "/users", [options])
        end
      end

      assert(perform_called)
    end

    it "does not inject user_id when user_id is already provided" do
      options = {user_id: 11}
      perform_called = false
      client.stub(:user_id, lambda {
        flunk("expected #user_id not to be called")
      }) do
        client.stub(:perform_request_with_objects, lambda { |verb, path, passed_options, klass|
          perform_called = true

          assert_equal(:get, verb)
          assert_equal("/users", path)
          assert_operator(passed_options, :equal?, options)
          assert_equal(Twitter::User, klass)
          []
        }) do
          client.send(:users_from_response, :get, "/users", [options])
        end
      end

      assert(perform_called)
    end
  end

  describe "#cursor_from_response_with_user" do
    it "injects current user_id when neither user_id nor screen_name is provided" do
      perform_called = false
      client.stub(:user_id, 77) do
        client.stub(:perform_get_with_cursor, lambda { |path, options, key, klass|
          perform_called = true

          assert_equal("/followers", path)
          assert_equal({user_id: 77}, options)
          assert_equal(:users, key)
          assert_equal(Twitter::User, klass)
          :cursor
        }) do
          assert_equal(:cursor, client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", []))
        end
      end

      assert(perform_called)
    end

    it "keeps explicit screen_name untouched" do
      options = {screen_name: "sferik"}
      perform_called = false
      client.stub(:user_id, lambda {
        flunk("expected #user_id not to be called")
      }) do
        client.stub(:perform_get_with_cursor, lambda { |path, passed_options, key, klass|
          perform_called = true

          assert_equal("/followers", path)
          assert_operator(passed_options, :equal?, options)
          assert_equal(:users, key)
          assert_equal(Twitter::User, klass)
          :cursor
        }) do
          assert_equal(:cursor, client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [options]))
        end
      end

      assert(perform_called)
    end
  end

  describe "#user_id?" do
    it "is false until user_id is memoized and true afterwards" do
      refute(client.send(:user_id?))

      client.send(:user_id)

      assert(client.send(:user_id?))
    end
  end

  describe "#merge_default_cursor!" do
    it "assigns the default cursor when cursor is nil" do
      options = {cursor: nil}
      client.send(:merge_default_cursor!, options)

      assert_equal(Twitter::REST::Utils::DEFAULT_CURSOR, options[:cursor])
    end
  end

  describe "#merge_user" do
    it "returns a new hash and keeps the original unchanged" do
      original = {trim_user: true}

      result = client.send(:merge_user, original, 123)

      assert_equal({trim_user: true, user_id: 123}, result)
      assert_equal({trim_user: true}, original)
    end

    it "respects an explicit prefix" do
      result = client.send(:merge_user, {}, 123, "target")

      assert_equal({target_user_id: 123}, result)
    end
  end

  describe "#merge_user!" do
    it "extracts screen_name from URI-like inputs" do
      hash = {}
      client.send(:merge_user!, hash, URI.parse("https://twitter.com/sferik"))

      assert_equal({screen_name: "sferik"}, hash)
    end
  end

  describe "#set_compound_key" do
    it "uses a nil prefix by default" do
      hash = {}

      assert_equal({screen_name: "sferik"}, client.send(:set_compound_key, "screen_name", "sferik", hash))
    end
  end

  describe "#merge_users" do
    it "returns a copy and does not mutate the input hash" do
      original = {trim_user: true}

      result = client.send(:merge_users, original, [1, "sferik"])

      assert_equal({trim_user: true}, original)
      assert_equal({trim_user: true, user_id: "1", screen_name: "sferik"}, result)
    end
  end

  describe "#merge_users!" do
    it "deduplicates users before collecting IDs and screen_names" do
      hash = {}
      users = [1, 1, "sferik", "sferik"]

      client.send(:merge_users!, hash, users)

      assert_equal("1", hash[:user_id])
      assert_equal("sferik", hash[:screen_name])
    end
  end

  describe "#collect_users" do
    it "collects IDs and screen names from all supported types" do
      users = [
        1,
        Twitter::User.new(id: 2),
        "sferik",
        URI.parse("https://twitter.com/erik"),
        Addressable::URI.parse("https://twitter.com/alice")
      ]

      user_ids, screen_names = client.send(:collect_users, users)

      assert_equal([1, 2], user_ids)
      assert_equal(%w[sferik erik alice], screen_names)
    end

    it "ignores unsupported user-like objects" do
      users = [1, Object.new, "sferik"]

      user_ids, screen_names = client.send(:collect_users, users)

      assert_equal([1], user_ids)
      assert_equal(["sferik"], screen_names)
    end
  end
end
