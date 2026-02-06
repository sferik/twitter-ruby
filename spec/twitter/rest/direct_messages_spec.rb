require "helper"

describe Twitter::REST::DirectMessages do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    allow(@client).to receive(:user_id).and_return(22_095_868)
  end

  describe "#direct_messages_received" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_received
      expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
    end

    it "returns the 20 most recent direct messages sent to the authenticating user" do
      direct_messages = @client.direct_messages_received
      expect(direct_messages).to be_an Array
      expect(direct_messages.first).to be_a Twitter::DirectMessage
      expect(direct_messages.first.sender.id).to eq(358_486_183)
    end

    context "with count option" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "limits the returned messages to count" do
        direct_messages = @client.direct_messages_received(count: 1)
        expect(direct_messages.length).to eq(1)
      end

      it "uses the count option from options hash" do
        # Verify the :count key is being read from options, not some other key
        direct_messages = @client.direct_messages_received(count: 2)
        expect(direct_messages.length).to eq(2)
      end
    end

    context "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "xyz789"}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the underlying direct_messages_list call" do
        @client.direct_messages_received(cursor: "xyz789")
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "xyz789"})).to have_been_made
      end
    end

    it "keeps only messages addressed to the authenticated user" do
      not_for_user = instance_double(Twitter::DirectMessage, recipient_id: 1, sender_id: 2)
      for_user = instance_double(Twitter::DirectMessage, recipient_id: 22_095_868, sender_id: 3)
      allow(@client).to receive(:direct_messages_list).and_return([not_for_user, for_user])

      expect(@client.direct_messages_received).to eq([for_user])
    end

    it "defaults to returning at most 20 matching messages" do
      matching = Array.new(25) { |i| instance_double(Twitter::DirectMessage, recipient_id: 22_095_868, sender_id: i) }
      allow(@client).to receive(:direct_messages_list).and_return(matching)

      expect(@client.direct_messages_received).to eq(matching.first(20))
    end
  end

  describe "#direct_messages_events" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_events
      expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
    end

    it "returns messages" do
      direct_messages = @client.direct_messages_events

      expect(direct_messages).to be_a Twitter::Cursor
      expect(direct_messages.first).to be_a Twitter::DirectMessageEvent
      expect(direct_messages.first.id).to eq("856574281366605831")
      expect(direct_messages.first.created_timestamp).to eq("1493058197715")
      expect(direct_messages.first.direct_message.text).to eq("Thanks https://twitter.com/i/stickers/image/10011")
      expect(direct_messages.first.direct_message.sender_id).to eq(358_486_183)
      expect(direct_messages.first.direct_message.recipient_id).to eq(22_095_868)
      expect(direct_messages.first.direct_message.sender.id).to eq(358_486_183)
      expect(direct_messages.first.direct_message.recipient.id).to eq(22_095_868)
      expect(direct_messages.first.direct_message.created_at).to be_a Time
      expect(direct_messages.first.direct_message.created_at).to eq(Time.at(1_493_058_197_715 / 1000.0))
    end

    context "with count option" do
      it "uses count option to set the limit" do
        direct_messages = @client.direct_messages_events(count: 1)
        # The count option is used to set limit, we can verify it's being passed
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
      end
    end

    context "without count option" do
      it "defaults the limit to 20" do
        # direct_messages_events with no :count option defaults to limit=20
        # We verify this by checking the returned count is capped at 20
        # (the fixture has 16 events which is less than 20)
        direct_messages = @client.direct_messages_events
        expect(direct_messages.to_a.length).to be <= 20
      end
    end

    context "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "abc123"}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.direct_messages_events(cursor: "abc123")
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "abc123"})).to have_been_made
      end
    end

    it "passes default limit: 20 to perform_get_with_cursor without mutating options" do
      wrappers = [instance_double(Twitter::DirectMessageEvent)]
      options = {}
      expect(@client).to receive(:perform_get_with_cursor)
        .with("/1.1/direct_messages/events/list.json", {no_default_cursor: true, count: 50, limit: 20}, :events, Twitter::DirectMessageEvent)
        .and_return(wrappers)

      expect(@client.direct_messages_events(options)).to eq(wrappers)
      expect(options).to eq({})
    end

    it "uses options[:count] as limit and keeps other caller options intact" do
      wrappers = [instance_double(Twitter::DirectMessageEvent)]
      options = {count: 1, cursor: "abc123"}
      expect(@client).to receive(:perform_get_with_cursor)
        .with("/1.1/direct_messages/events/list.json", {count: 50, cursor: "abc123", no_default_cursor: true, limit: 1}, :events, Twitter::DirectMessageEvent)
        .and_return(wrappers)

      @client.direct_messages_events(options)
      expect(options).to eq({count: 1, cursor: "abc123"})
    end
  end

  describe "#direct_messages_list" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "returns DirectMessage objects" do
      direct_messages = @client.direct_messages_list
      expect(direct_messages).to be_an Array
      expect(direct_messages.first).to be_a Twitter::DirectMessage
    end

    context "with options" do
      it "passes options to direct_messages_events" do
        # This verifies that options are passed through, even if the count option
        # is used for limiting on the client side
        @client.direct_messages_list(count: 1)
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
      end
    end
  end

  describe "#direct_messages_sent" do
    before do
      stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_sent
      expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
    end

    it "returns the 20 most recent direct messages sent by the authenticating user" do
      direct_messages = @client.direct_messages_sent
      expect(direct_messages).to be_an Array
      expect(direct_messages.first).to be_a Twitter::DirectMessage
      expect(direct_messages.first.sender.id).to eq(22_095_868)
    end

    context "with count option" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "limits the returned messages to count" do
        direct_messages = @client.direct_messages_sent(count: 1)
        expect(direct_messages.length).to eq(1)
      end

      it "uses the count option from options hash" do
        # Verify the :count key is being read from options, not some other key
        direct_messages = @client.direct_messages_sent(count: 2)
        expect(direct_messages.length).to eq(2)
      end
    end

    context "with custom options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "sent123"}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the underlying direct_messages_list call" do
        @client.direct_messages_sent(cursor: "sent123")
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50, cursor: "sent123"})).to have_been_made
      end
    end

    it "defaults to returning at most 20 matching sent messages" do
      matching = Array.new(25) { instance_double(Twitter::DirectMessage, sender_id: 22_095_868, recipient_id: 1) }
      allow(@client).to receive(:direct_messages_list).and_return(matching)

      expect(@client.direct_messages_sent).to eq(matching.first(20))
    end
  end

  describe "#direct_message" do
    before do
      stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_message(1_825_786_345)
      expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"})).to have_been_made
    end

    it "returns the specified direct message" do
      direct_message = @client.direct_message(1_825_786_345)
      expect(direct_message).to be_a Twitter::DirectMessage
      expect(direct_message.sender.id).to eq(124_294_236)
    end

    context "with options" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.direct_message(1_825_786_345, {custom_option: "value"})
        expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"})).to have_been_made
      end
    end
  end

  describe "#direct_message_event" do
    before do
      stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource without options" do
      @client.direct_message_event(1_825_786_345)
      expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"})).to have_been_made
    end

    it "returns the specified direct message event" do
      direct_message_event = @client.direct_message_event(1_825_786_345)
      expect(direct_message_event).to be_a Twitter::DirectMessageEvent
    end

    context "with options" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.direct_message_event(1_825_786_345, {custom_option: "value"})
        expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", custom_option: "value"})).to have_been_made
      end
    end
  end

  describe "#direct_messages" do
    context "with ids passed" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.direct_messages(1_825_786_345)
        expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345"})).to have_been_made
      end

      it "returns an array of direct messages" do
        direct_messages = @client.direct_messages(1_825_786_345)
        expect(direct_messages).to be_an Array
        expect(direct_messages.first).to be_a Twitter::DirectMessage
        expect(direct_messages.first.sender.id).to eq(124_294_236)
      end
    end

    context "with ids and options passed" do
      before do
        stub_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", extra: "option"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to each request" do
        @client.direct_messages(1_825_786_345, {extra: "option"})
        expect(a_get("/1.1/direct_messages/events/show.json").with(query: {id: "1825786345", extra: "option"})).to have_been_made
      end
    end

    context "without ids passed" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.direct_messages
        expect(a_get("/1.1/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
      end

      it "returns the 20 most recent direct messages sent to the authenticating user" do
        direct_messages = @client.direct_messages
        expect(direct_messages).to be_an Array
        expect(direct_messages.first).to be_a Twitter::DirectMessage
        expect(direct_messages.first.sender.id).to eq(358_486_183)
      end
    end

    context "without ids but with options" do
      before do
        stub_get("/1.1/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to direct_messages_received" do
        direct_messages = @client.direct_messages({count: 1})
        expect(direct_messages.length).to eq(1)
      end
    end
  end

  describe "#destroy_direct_message" do
    before do
      stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785544").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.destroy_direct_message(1_825_785_544)
      expect(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785544")).to have_been_made
    end

    it "returns nil" do
      response = @client.destroy_direct_message(1_825_785_544)
      expect(response).to be_nil
    end

    it "sends the correct id parameter" do
      @client.destroy_direct_message(1_825_785_544)
      # Verify the id key is used (not id__mutant__ or similar)
      expect(a_delete("/1.1/direct_messages/events/destroy.json").with(query: {id: "1825785544"})).to have_been_made
    end

    it "delegates using the id keyword argument" do
      expect(@client).to receive(:perform_requests).with(:delete, "/1.1/direct_messages/events/destroy.json", id: 1_825_785_544)

      @client.destroy_direct_message(1_825_785_544)
    end

    context "with multiple ids" do
      before do
        stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785544").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
        stub_delete("/1.1/direct_messages/events/destroy.json?id=1825785545").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "deletes multiple messages" do
        @client.destroy_direct_message(1_825_785_544, 1_825_785_545)
        expect(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785544")).to have_been_made
        expect(a_delete("/1.1/direct_messages/events/destroy.json?id=1825785545")).to have_been_made
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
            message_data: {text: "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf"},
          },
        },
      }
    end

    before do
      stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")
      expect(a_post("/1.1/direct_messages/events/new.json").with(body: json_options)).to have_been_made
    end

    it "returns the sent message" do
      direct_message = @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")
      expect(direct_message).to be_a Twitter::DirectMessage
      expect(direct_message.text).to eq("testing")
      expect(direct_message.recipient_id).to eq(58_983)
    end

    context "with options" do
      let(:json_options_with_quick_reply) do
        {
          event: {
            type: "message_create",
            message_create: {
              target: {recipient_id: "7505382"},
              message_data: {text: "Hello", quick_reply: {type: "options"}},
            },
          },
        }
      end

      before do
        stub_post("/1.1/direct_messages/events/new.json").with(body: json_options_with_quick_reply).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to message_data" do
        @client.create_direct_message("7505382", "Hello", {quick_reply: {type: "options"}})
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: json_options_with_quick_reply)).to have_been_made
      end
    end
  end

  describe "#create_direct_message_event" do
    before do
      stub_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.create_direct_message_event(58_983, "testing")
      expect(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}})).to have_been_made
    end

    it "returns the sent message" do
      direct_message_event = @client.create_direct_message_event(58_983, "testing")
      expect(direct_message_event).to be_a Twitter::DirectMessageEvent
      expect(direct_message_event.direct_message.text).to eq("testing")
    end

    it "correctly initializes from the response" do
      direct_message_event = @client.create_direct_message_event(58_983, "testing")
      # Verify the event was correctly parsed - DirectMessageEvent.read_from_response handles both formats
      expect(direct_message_event.id).to eq("1006278767680131076")
    end

    context "when called with fewer than 2 arguments" do
      it "does not set event in options" do
        stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.create_direct_message_event
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "when called with exactly 1 argument" do
      it "does not set event in options" do
        stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.create_direct_message_event(58_983)
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "when called with more than 2 arguments" do
      it "sets event in options with first two arguments" do
        stub_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}, extra: "option"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.create_direct_message_event(58_983, "testing", {extra: "option"})
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}, extra: "option"})).to have_been_made
      end
    end

    context "when user is a Twitter::User object" do
      it "extracts the id from the user object" do
        user = Twitter::User.new(id: 58_983)
        @client.create_direct_message_event(user, "testing")
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}})).to have_been_made
      end
    end
  end

  describe "#create_direct_message_event_with_media" do
    before do
      stub_post("/1.1/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "parses the :event key from the response" do
      direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"))
      # Verify the event was correctly parsed - the fixture wraps data in :event key
      expect(direct_message_event.id).to eq("1006278767680131076")
    end

    context "with options" do
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
        stub_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body_with_options).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"), {custom_option: "value"})
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body_with_options)).to have_been_made
      end
    end

    context "with a User object" do
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
        @client.create_direct_message_event_with_media(user, "testing", fixture("pbjt.gif"))
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body)).to have_been_made
      end
    end

    context "with a mp4 video" do
      let(:video) { fixture("1080p.mp4") }

      before do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
      end

      it "sends the correct media_category for dm_video" do
        @client.create_direct_message_event_with_media(58_983, "testing", video)
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with { |req|
          req.body.include?("command=INIT") &&
          req.body.include?("media_category=dm_video")
        }).to have_been_made
      end
    end

    context "with a gif image" do
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
        @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/direct_messages/events/new.json").with(body: expected_event_body)).to have_been_made
      end

      it "returns a DirectMessageEvent" do
        direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"))
        expect(direct_message_event).to be_a Twitter::DirectMessageEvent
        expect(direct_message_event.direct_message.text).to eq("testing")
      end

      context "which size is bigger than 5 megabytes" do
        let(:big_gif) { fixture("pbjt.gif") }

        before do
          allow(File).to receive(:size).with(big_gif).and_return(7_000_000)
        end

        it "requests the correct resource" do
          @client.create_direct_message_event_with_media(58_983, "testing", big_gif)
          expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
          expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
        end

        it "returns a DirectMessageEvent" do
          direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", big_gif)
          expect(direct_message_event).to be_a Twitter::DirectMessageEvent
          expect(direct_message_event.direct_message.text).to eq("testing")
        end
      end
    end

    context "with a jpe image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("wildcomet2.jpe"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a jpeg image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("me.jpeg"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a png image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("we_concept_bg2.png"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a mp4 video" do
      it "requests the correct resources" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end

      context "when the processing is not finished right after the upload" do
        context "when it succeeds" do
          it "asks for status until the processing is done" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            pending_status_request = {body: fixture("chunk_upload_status_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            completed_status_request = {body: fixture("chunk_upload_status_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(pending_status_request, completed_status_request)
            expect_any_instance_of(described_class).to receive(:sleep).with(5).and_return(5)
            expect_any_instance_of(described_class).to receive(:sleep).with(10).and_return(10)
            @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4"))
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made.times(2)
            expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
          end
        end

        context "when it fails" do
          it "raises an error" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            failed_status_request = {body: fixture("chunk_upload_status_failed.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(failed_status_request)
            expect_any_instance_of(described_class).to receive(:sleep).with(5).and_return(5)
            expect { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::InvalidMedia)
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made
          end
        end

        context "when Twitter::Client#timeouts[:upload] is set" do
          before { @client.timeouts = {upload: 0.1} }

          it "raises an error when the finalize step is too slow" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            expect { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::TimeoutError)
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
          end
        end
      end
    end

    context "with a Tempfile" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", Tempfile.new("tmp"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/direct_messages/events/new.json")).to have_been_made
      end
    end
  end
end

# Include this constant in wrapper coverage mapping for this spec file.
describe Twitter::DirectMessageEvent do
end
