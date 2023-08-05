require "helper"

describe Twitter::REST::DirectMessages do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    allow(@client).to receive(:user_id).and_return(22_095_868)
  end

  describe "#direct_messages_received" do
    before do
      stub_get("/2/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_received
      expect(a_get("/2/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
    end

    it "returns the 20 most recent direct messages sent to the authenticating user" do
      direct_messages = @client.direct_messages_received
      expect(direct_messages).to be_an Array
      expect(direct_messages.first).to be_a Twitter::DirectMessage
      expect(direct_messages.first.sender.id).to eq(358_486_183)
    end
  end

  describe "#direct_messages_events" do
    before do
      stub_get("/2/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_events
      expect(a_get("/2/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
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
    end
  end

  describe "#direct_messages_sent" do
    before do
      stub_get("/2/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_messages_sent
      expect(a_get("/2/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
    end

    it "returns the 20 most recent direct messages sent by the authenticating user" do
      direct_messages = @client.direct_messages_sent
      expect(direct_messages).to be_an Array
      expect(direct_messages.first).to be_a Twitter::DirectMessage
      expect(direct_messages.first.sender.id).to eq(22_095_868)
    end
  end

  describe "#direct_message" do
    before do
      stub_get("/2/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.direct_message(1_825_786_345)
      expect(a_get("/2/direct_messages/events/show.json").with(query: {id: "1825786345"})).to have_been_made
    end

    it "returns the specified direct message" do
      direct_message = @client.direct_message(1_825_786_345)
      expect(direct_message).to be_a Twitter::DirectMessage
      expect(direct_message.sender.id).to eq(124_294_236)
    end
  end

  describe "#direct_messages" do
    context "with ids passed" do
      before do
        stub_get("/2/direct_messages/events/show.json").with(query: {id: "1825786345"}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.direct_messages(1_825_786_345)
        expect(a_get("/2/direct_messages/events/show.json").with(query: {id: "1825786345"})).to have_been_made
      end

      it "returns an array of direct messages" do
        direct_messages = @client.direct_messages(1_825_786_345)
        expect(direct_messages).to be_an Array
        expect(direct_messages.first).to be_a Twitter::DirectMessage
        expect(direct_messages.first.sender.id).to eq(124_294_236)
      end
    end

    context "without ids passed" do
      before do
        stub_get("/2/direct_messages/events/list.json").with(query: {count: 50}).to_return(body: fixture("direct_message_events.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.direct_messages
        expect(a_get("/2/direct_messages/events/list.json").with(query: {count: 50})).to have_been_made
      end

      it "returns the 20 most recent direct messages sent to the authenticating user" do
        direct_messages = @client.direct_messages
        expect(direct_messages).to be_an Array
        expect(direct_messages.first).to be_a Twitter::DirectMessage
        expect(direct_messages.first.sender.id).to eq(358_486_183)
      end
    end
  end

  describe "#destroy_direct_message" do
    before do
      stub_delete("/2/direct_messages/events/destroy.json?id=1825785544").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.destroy_direct_message(1_825_785_544)
      expect(a_delete("/2/direct_messages/events/destroy.json?id=1825785544")).to have_been_made
    end

    it "returns nil" do
      response = @client.destroy_direct_message(1_825_785_544)
      expect(response).to be_nil
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
      stub_post("/2/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")
      expect(a_post("/2/direct_messages/events/new.json").with(body: json_options)).to have_been_made
    end

    it "returns the sent message" do
      direct_message = @client.create_direct_message("7505382", "My #newride from @PUBLICBikes. Don't you want one? https://t.co/7HIwCl68Y8 https://t.co/JSSxDPr4Sf")
      expect(direct_message).to be_a Twitter::DirectMessage
      expect(direct_message.text).to eq("testing")
      expect(direct_message.recipient_id).to eq(58_983)
    end
  end

  describe "#create_direct_message_event" do
    before do
      stub_post("/2/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}}).to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.create_direct_message_event(58_983, "testing")
      expect(a_post("/2/direct_messages/events/new.json").with(body: {event: {type: "message_create", message_create: {target: {recipient_id: 58_983}, message_data: {text: "testing"}}}})).to have_been_made
    end

    it "returns the sent message" do
      direct_message_event = @client.create_direct_message_event(58_983, "testing")
      expect(direct_message_event).to be_a Twitter::DirectMessageEvent
      expect(direct_message_event.direct_message.text).to eq("testing")
    end
  end

  describe "#create_direct_message_event_with_media" do
    before do
      stub_post("/2/direct_messages/events/new.json").to_return(body: fixture("direct_message_event.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_request(:post, "https://upload.twitter.com/2/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    context "with a gif image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"))
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end

      it "returns a DirectMessageEvent" do
        direct_message_event = @client.create_direct_message_event_with_media(58_983, "testing", fixture("pbjt.gif"))
        expect(direct_message_event).to be_a Twitter::DirectMessageEvent
        expect(direct_message_event.direct_message.text).to eq("testing")
      end

      context "which size is bigger than 5 megabytes" do
        let(:big_gif) { fixture("pbjt.gif") }

        before do
          expect(File).to receive(:size).with(big_gif).and_return(7_000_000)
        end

        it "requests the correct resource" do
          @client.create_direct_message_event_with_media(58_983, "testing", big_gif)
          expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made.times(3)
          expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
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
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a jpeg image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("me.jpeg"))
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a png image" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("we_concept_bg2.png"))
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end
    end

    context "with a mp4 video" do
      it "requests the correct resources" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/2/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4"))
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made.times(3)
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end

      context "when the processing is not finished right after the upload" do
        context "when it succeeds" do
          it "asks for status until the processing is done" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            pending_status_request = {body: fixture("chunk_upload_status_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            completed_status_request = {body: fixture("chunk_upload_status_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/2/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/2/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(pending_status_request, completed_status_request)
            expect_any_instance_of(described_class).to receive(:sleep).with(5).and_return(5)
            expect_any_instance_of(described_class).to receive(:sleep).with(10).and_return(10)
            @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4"))
            expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/2/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made.times(2)
            expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
          end
        end

        context "when it fails" do
          it "raises an error" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            failed_status_request = {body: fixture("chunk_upload_status_failed.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/2/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/2/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(failed_status_request)
            expect_any_instance_of(described_class).to receive(:sleep).with(5).and_return(5)
            expect { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::InvalidMedia)
            expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/2/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made
          end
        end

        context "when Twitter::Client#timeouts[:upload] is set" do
          before { @client.timeouts = {upload: 0.1} }

          it "raises an error when the finalize step is too slow" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/2/media/upload.json").to_return(init_request, append_request, finalize_request)
            expect { @client.create_direct_message_event_with_media(58_983, "You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::TimeoutError)
            expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made.times(3)
          end
        end
      end
    end

    context "with a Tempfile" do
      it "requests the correct resource" do
        @client.create_direct_message_event_with_media(58_983, "You always have options", Tempfile.new("tmp"))
        expect(a_request(:post, "https://upload.twitter.com/2/media/upload.json")).to have_been_made
        expect(a_post("/2/direct_messages/events/new.json")).to have_been_made
      end
    end
  end
end
