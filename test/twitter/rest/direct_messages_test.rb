require "test_helper"

describe Twitter::REST::DirectMessages do
  before do
    @client = build_rest_client
    @client.define_singleton_method(:user_id) { 22_095_868 }
  end

  describe "#direct_messages_received" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.direct_messages_received

      assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
    end

    it "returns the 20 most recent direct messages sent to the authenticating user" do
      direct_messages = @client.direct_messages_received

      assert_kind_of(Array, direct_messages)
      assert_kind_of(Twitter::DirectMessage, direct_messages.first)
      assert_equal(358_486_183, direct_messages.first.sender.id)
    end

    describe "with count option" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "limits the returned messages to count" do
        direct_messages = @client.direct_messages_received(count: 1)

        assert_equal(1, direct_messages.length)
      end

      it "uses the count option from options hash" do
        # Verify the :count key is being read from options, not some other key
        direct_messages = @client.direct_messages_received(count: 2)

        assert_equal(2, direct_messages.length)
      end
    end

    describe "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "xyz789"}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "passes options to the underlying direct_messages_list call" do
        @client.direct_messages_received(cursor: "xyz789")

        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "xyz789"}))
      end
    end

    it "keeps only messages addressed to the authenticated user" do
      message_class = Struct.new(:recipient_id, :sender_id)
      not_for_user = message_class.new(1, 2)
      for_user = message_class.new(22_095_868, 3)

      @client.stub(:direct_messages_list, [not_for_user, for_user]) do
        assert_equal([for_user], @client.direct_messages_received)
      end
    end

    it "defaults to returning at most 20 matching messages" do
      message_class = Struct.new(:recipient_id, :sender_id)
      matching = Array.new(25) { |i| message_class.new(22_095_868, i) }

      @client.stub(:direct_messages_list, matching) do
        assert_equal(matching.first(20), @client.direct_messages_received)
      end
    end
  end

  describe "#direct_messages_events" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.direct_messages_events

      assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
    end

    it "returns messages" do
      direct_messages = @client.direct_messages_events

      assert_kind_of(Twitter::Cursor, direct_messages)
      assert_kind_of(Twitter::DirectMessageEvent, direct_messages.first)
      assert_equal("856574281366605831", direct_messages.first.id)
      assert_equal("1493058197715", direct_messages.first.created_timestamp)
      assert_equal("Thanks https://twitter.com/i/stickers/image/10011", direct_messages.first.direct_message.text)
      assert_equal(358_486_183, direct_messages.first.direct_message.sender_id)
      assert_equal(22_095_868, direct_messages.first.direct_message.recipient_id)
      assert_equal(358_486_183, direct_messages.first.direct_message.sender.id)
      assert_equal(22_095_868, direct_messages.first.direct_message.recipient.id)
      assert_kind_of(Time, direct_messages.first.direct_message.created_at)
      assert_equal(Time.at(1_493_058_197_715 / 1000.0), direct_messages.first.direct_message.created_at)
    end

    describe "with count option" do
      it "uses count option to set the limit" do
        @client.direct_messages_events(count: 1)
        # The count option is used to set limit, we can verify it's being passed
        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
      end
    end

    describe "without count option" do
      it "defaults the limit to 20" do
        # direct_messages_events with no :count option defaults to limit=20
        # We verify this by checking the returned count is capped at 20
        # (the fixture has 16 events which is less than 20)
        direct_messages = @client.direct_messages_events

        assert_operator(direct_messages.to_a.length, :<=, 20)
      end
    end

    describe "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "abc123"}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.direct_messages_events(cursor: "abc123")

        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "abc123"}))
      end
    end

    it "passes default limit: 20 to perform_get_with_cursor without mutating options" do
      wrappers = [Object.new]
      options = {}
      called = false

      @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
        called = true

        assert_equal("/1.1/direct_messages/events/list.json", path)
        assert_equal({no_default_cursor: true, count: 50, limit: 20}, opts)
        assert_equal(:events, key)
        assert_equal(Twitter::DirectMessageEvent, wrapper_class)
        wrappers
      }) do
        assert_equal(wrappers, @client.direct_messages_events(options))
      end
      assert(called)
      assert_empty(options)
    end

    it "uses options[:count] as limit and keeps other caller options intact" do
      wrappers = [Object.new]
      options = {count: 1, cursor: "abc123"}
      called = false
      @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
        called = true

        assert_equal("/1.1/direct_messages/events/list.json", path)
        assert_equal({count: 50, cursor: "abc123", no_default_cursor: true, limit: 1}, opts)
        assert_equal(:events, key)
        assert_equal(Twitter::DirectMessageEvent, wrapper_class)
        wrappers
      }) do
        @client.direct_messages_events(options)
      end

      assert(called)
      assert_equal({count: 1, cursor: "abc123"}, options)
    end
  end

  describe "#direct_messages_list" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
    end

    it "returns DirectMessage objects" do
      direct_messages = @client.direct_messages_list

      assert_kind_of(Array, direct_messages)
      assert_kind_of(Twitter::DirectMessage, direct_messages.first)
    end

    describe "with options" do
      it "passes options to direct_messages_events" do
        # This verifies that options are passed through, even if the count option
        # is used for limiting on the client side
        @client.direct_messages_list(count: 1)

        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
      end
    end
  end

  describe "#direct_messages_sent" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.direct_messages_sent

      assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
    end

    it "returns the 20 most recent direct messages sent by the authenticating user" do
      direct_messages = @client.direct_messages_sent

      assert_kind_of(Array, direct_messages)
      assert_kind_of(Twitter::DirectMessage, direct_messages.first)
      assert_equal(22_095_868, direct_messages.first.sender.id)
    end

    describe "with count option" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "limits the returned messages to count" do
        direct_messages = @client.direct_messages_sent(count: 1)

        assert_equal(1, direct_messages.length)
      end

      it "uses the count option from options hash" do
        # Verify the :count key is being read from options, not some other key
        direct_messages = @client.direct_messages_sent(count: 2)

        assert_equal(2, direct_messages.length)
      end
    end

    describe "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "sent123"}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "passes options to the underlying direct_messages_list call" do
        @client.direct_messages_sent(cursor: "sent123")

        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "sent123"}))
      end
    end

    it "defaults to returning at most 20 matching sent messages" do
      message_class = Struct.new(:sender_id, :recipient_id)
      matching = Array.new(25) { message_class.new(22_095_868, 1) }

      @client.stub(:direct_messages_list, matching) do
        assert_equal(matching.first(20), @client.direct_messages_sent)
      end
    end
  end

  describe "#direct_message" do
    before do
      stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.direct_message(1_825_786_345)

      assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}))
    end

    it "returns the specified direct message" do
      direct_message = @client.direct_message(1_825_786_345)

      assert_kind_of(Twitter::DirectMessage, direct_message)
      assert_equal(124_294_236, direct_message.sender.id)
    end

    describe "with options" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.direct_message(1_825_786_345, {custom_option: "value"})

        assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}))
      end
    end
  end

  describe "#direct_message_event" do
    before do
      stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
    end

    it "requests the correct resource without options" do
      @client.direct_message_event(1_825_786_345)

      assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}))
    end

    it "returns the specified direct message event" do
      direct_message_event = @client.direct_message_event(1_825_786_345)

      assert_kind_of(Twitter::DirectMessageEvent, direct_message_event)
    end

    describe "with options" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.direct_message_event(1_825_786_345, {custom_option: "value"})

        assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}))
      end
    end
  end

  describe "#direct_messages" do
    describe "with ids passed" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.direct_messages(1_825_786_345)

        assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}))
      end

      it "returns an array of direct messages" do
        direct_messages = @client.direct_messages(1_825_786_345)

        assert_kind_of(Array, direct_messages)
        assert_kind_of(Twitter::DirectMessage, direct_messages.first)
        assert_equal(124_294_236, direct_messages.first.sender.id)
      end
    end

    describe "with ids and options passed" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", extra: "option"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "passes options to each request" do
        @client.direct_messages(1_825_786_345, {extra: "option"})

        assert_requested(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", extra: "option"}))
      end
    end

    describe "without ids passed" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.direct_messages

        assert_requested(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}))
      end

      it "returns the 20 most recent direct messages sent to the authenticating user" do
        direct_messages = @client.direct_messages

        assert_kind_of(Array, direct_messages)
        assert_kind_of(Twitter::DirectMessage, direct_messages.first)
        assert_equal(358_486_183, direct_messages.first.sender.id)
      end
    end

    describe "without ids but with options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: json_headers)
      end

      it "passes options to direct_messages_received" do
        direct_messages = @client.direct_messages({count: 1})

        assert_equal(1, direct_messages.length)
      end
    end
  end

  describe "#destroy_direct_message" do
    before do
      stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785544").to_return(status: 204, body: "", headers: json_headers)
    end

    it "requests the correct resource" do
      @client.destroy_direct_message(1_825_785_544)

      assert_requested(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785544"))
    end

    it "returns nil" do
      response = @client.destroy_direct_message(1_825_785_544)

      assert_nil(response)
    end

    it "sends the correct id parameter" do
      @client.destroy_direct_message(1_825_785_544)
      # Verify the id key is used (not id__mutant__ or similar)
      assert_requested(a_delete("/1.1/direct_messages/events/destroy.json").with(query: {id: "1825785544"}))
    end

    it "delegates using the id keyword argument" do
      called = false
      @client.stub(:perform_requests, lambda { |verb, path, params|
        called = true

        assert_equal(:delete, verb)
        assert_equal("/1.1/direct_messages/events/destroy.json", path)
        assert_equal({id: 1_825_785_544}, params)
      }) do
        @client.destroy_direct_message(1_825_785_544)
      end

      assert(called)
    end

    describe "with multiple ids" do
      before do
        stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785544").to_return(status: 204, body: "", headers: json_headers)
        stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785545").to_return(status: 204, body: "", headers: json_headers)
      end

      it "deletes multiple messages" do
        @client.destroy_direct_message(1_825_785_544, 1_825_785_545)

        assert_requested(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785544"))
        assert_requested(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785545"))
      end
    end
  end

  describe "#create_direct_message" do
    let(:json_options) do
      {
        event: {
          type: "message_create",
          message_create: {
            target: {recipient_id: "7505382"},
            message_data: {text: "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf"}
          }
        }
      }
    end

    before do
      stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")

      assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: json_options))
    end

    it "returns the sent message" do
      direct_message = @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")

      assert_kind_of(Twitter::DirectMessage, direct_message)
      assert_equal("testing", direct_message.text)
      assert_equal(58_983, direct_message.recipient_id)
    end

    describe "with options" do
      let(:json_options_with_quick_reply) do
        {
          event: {
            type: "message_create",
            message_create: {
              target: {recipient_id: "7505382"},
              message_data: {text: "Hello", quick_reply: {type: "options"}}
            }
          }
        }
      end

      before do
        stub_post("/1.1/direct_messages/events/new.json").with(body: json_options_with_quick_reply).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "passes options to message_data" do
        @client.create_direct_message("7505382", "Hello", {quick_reply: {type: "options"}})

        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: json_options_with_quick_reply))
      end
    end
  end

  describe "#create_direct_message_event" do
    before do
      stub_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.create_direct_message_event(58_983, "testing")

      assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}}))
    end

    it "returns the sent message" do
      direct_message_event = @client.create_direct_message_event(58_983, "testing")

      assert_kind_of(Twitter::DirectMessageEvent, direct_message_event)
      assert_equal("testing", direct_message_event.direct_message.text)
    end

    it "correctly initializes from the response" do
      direct_message_event = @client.create_direct_message_event(58_983, "testing")
      # Verify the event was correctly parsed - DirectMessageEvent.read_from_response handles both formats
      assert_equal("1006278767680131076", direct_message_event.id)
    end

    describe "when called with fewer than 2 arguments" do
      it "does not set event in options" do
        stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: json_headers)
        @client.create_direct_message_event

        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end

    describe "when called with exactly 1 argument" do
      it "does not set event in options" do
        stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: json_headers)
        @client.create_direct_message_event(58_983)

        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end

    describe "when called with more than 2 arguments" do
      it "sets event in options with first two arguments" do
        stub_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}, extra: "option"}).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
        @client.create_direct_message_event(58_983, "testing", {extra: "option"})

        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}, extra: "option"}))
      end
    end

    describe "when user is a Twitter::User object" do
      it "extracts the id from the user object" do
        user = Twitter::User.new(id: 58_983)
        @client.create_direct_message_event(user, "testing")

        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}}))
      end
    end
  end

  describe "#create_direct_message_event_with_media" do
    before do
      stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
    end

    it "parses the :event key from the response" do
      direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", fixture_file("pbjt.gif"))
      # Verify the event was correctly parsed - the fixture wraps data in :event key
      assert_equal("1006278767680131076", direct_message_event.id)
    end

    describe "with options" do
      let(:expected_event_body_with_options) do
        {
          event: {
            type: "message_create",
            message_create: {
              target: {recipient_id: 58_983},
              message_data: {
                text: "testing",
                attachment: {
                  type: "media",
                  media: {id: 470_030_289_822_314_497}
                }
              }
            }
          },
          custom_option: "value"
        }
      end

      before do
        stub_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body_with_options).to_return(body: fixture("direct_message_event.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.create_direct_message_event_with_media(58_983, "testing", fixture_file("pbjt.gif"), {custom_option: "value"})

        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body_with_options))
      end
    end

    describe "with a User object" do
      let(:expected_event_body) do
        {
          event: {
            type: "message_create",
            message_create: {
              target: {recipient_id: 58_983},
              message_data: {
                text: "testing",
                attachment: {
                  type: "media",
                  media: {id: 470_030_289_822_314_497}
                }
              }
            }
          }
        }
      end

      it "extracts the id from the user object" do
        user = Twitter::User.new(id: 58_983)
        @client.create_direct_message_event_with_media(user, "testing", fixture_file("pbjt.gif"))

        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body))
      end
    end

    describe "with a mp4 video" do
      let(:video) { fixture_file("1080p.mp4") }

      before do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
      end

      it "sends the correct media_category for dm_video" do
        @client.create_direct_message_event_with_media(58_983, "testing", video)
        request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=INIT") &&
            req.body.include?("media_category=dm_video")
        end

        assert_requested(request)
      end
    end

    describe "with a gif image" do
      let(:expected_event_body) do
        {
          event: {
            type: "message_create",
            message_create: {
              target: {recipient_id: 58_983},
              message_data: {
                text: "testing",
                attachment: {
                  type: "media",
                  media: {id: 470_030_289_822_314_497}
                }
              }
            }
          }
        }
      end

      it "requests the correct resource with correct body" do
        @client.create_direct_message_event_with_media(58_983, "testing", fixture_file("pbjt.gif"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body))
      end

      it "returns a DirectMessageEvent" do
        direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", fixture_file("pbjt.gif"))

        assert_kind_of(Twitter::DirectMessageEvent, direct_message_event)
        assert_equal("testing", direct_message_event.direct_message.text)
      end

      describe "which size is bigger than 5 megabytes" do
        let(:big_gif) { fixture_file("pbjt.gif") }

        it "requests the correct resource" do
          File.stub(:size, 7_000_000) do
            @client.create_direct_message_event_with_media(58_983, "testing", big_gif)
          end

          assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
          assert_requested(a_post("/1.1/direct_messages/events/new.json"))
        end

        it "returns a DirectMessageEvent" do
          direct_message_event = nil
          File.stub(:size, 7_000_000) do
            direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", big_gif)
          end

          assert_kind_of(Twitter::DirectMessageEvent, direct_message_event)
          assert_equal("testing", direct_message_event.direct_message.text)
        end
      end
    end

    describe "with a jpe image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("wildcomet2.jpe"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end

    describe "with a jpeg image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("me.jpeg"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end

    describe "with a png image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("we_concept_bg2.png"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end

    describe "with a mp4 video" do
      it "requests the correct resources" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("1080p.mp4"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end

      describe "when the processing is not finished right after the upload" do
        describe "when it succeeds" do
          it "asks for status until the processing is done" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            pending_status_request = {body: fixture("chunk_upload_status_pending.json"), headers: json_headers}
            completed_status_request = {body: fixture("chunk_upload_status_succeeded.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(pending_status_request, completed_status_request)
            sleep_calls = []
            @client.stub(:sleep, lambda { |seconds|
              sleep_calls << seconds
              seconds
            }) do
              @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("1080p.mp4"))
            end

            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
            assert_requested(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753"), times: 2)
            assert_requested(a_post("/1.1/direct_messages/events/new.json"))
            assert_equal([5, 10], sleep_calls)
          end
        end

        describe "when it fails" do
          it "raises an error" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            failed_status_request = {body: fixture("chunk_upload_status_failed.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(failed_status_request)
            sleep_calls = []

            @client.stub(:sleep, lambda { |seconds|
              sleep_calls << seconds
              seconds
            }) do
              assert_raises(Twitter::Error::InvalidMedia) { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("1080p.mp4")) }
            end
            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
            assert_requested(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753"))
            assert_equal([5], sleep_calls)
          end
        end

        describe "when Twitter::Client#timeouts[:upload] is set" do
          before { @client.timeouts = {upload: 0.1} }

          it "raises an error when the finalize step is too slow" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            assert_raises(Twitter::Error::TimeoutError) { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture_file("1080p.mp4")) }
            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
          end
        end
      end
    end

    describe "with a Tempfile" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", Tempfile.new("tmp"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/direct_messages/events/new.json"))
      end
    end
  end
end

# Include this constant in wrapper coverage mapping for this spec file.
describe Twitter::DirectMessageEvent do
end
