require "test_helper"

describe Twitter::DirectMessageEvent do
  let(:event_attrs) do
    {
      id: "1006278767680131076",
      created_timestamp: "1528750528627",
      message_create: {
        target: {recipient_id: "58983"},
        sender_id: "124294236",
        message_data: {
          text: "first https://t.co/one second https://t.co/two",
          entities: {
            hashtags: [],
            symbols: [],
            user_mentions: [],
            urls: [
              {url: "https://t.co/one", expanded_url: "https://example.com/one"},
              {url: "https://t.co/two", expanded_url: "https://example.com/two"}
            ]
          }
        }
      }
    }
  end

  describe "#initialize" do
    it "accepts wrapped :event responses" do
      event = Twitter::DirectMessageEvent.new(event: event_attrs)

      assert_equal("1006278767680131076", event.id)
      assert_equal(1_006_278_767_680_131_076, event.direct_message.id)
      assert_equal(124_294_236, event.direct_message.sender_id)
      assert_equal(58_983, event.direct_message.recipient_id)
    end

    it "accepts unwrapped responses and expands the first URL mapping" do
      event = Twitter::DirectMessageEvent.new(event_attrs)

      assert_equal("first https://example.com/one second https://t.co/two", event.direct_message.text)
    end

    it "expands every occurrence of the first URL mapping" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:text] = "repeat https://t.co/one and https://t.co/one"
      attrs[:message_create][:message_data][:entities][:urls] = [
        {url: "https://t.co/one", expanded_url: "https://example.com/one"}
      ]

      event = Twitter::DirectMessageEvent.new(attrs)

      assert_equal("repeat https://example.com/one and https://example.com/one", event.direct_message.text)
    end

    it "raises NoMethodError when message_create is missing" do
      assert_raises(NoMethodError) do
        Twitter::DirectMessageEvent.new(id: "1", created_timestamp: "1")
      end
    end

    it "uses [] to access the first URL mapping" do
      urls_class = Class.new do
        def any?
          true
        end

        def [](_index)
          {url: "https://t.co/primary", expanded_url: "https://example.com/primary"}
        end

        def at(_index)
          {url: "https://t.co/at", expanded_url: "https://example.com/at"}
        end

        def fetch(_index)
          {url: "https://t.co/fetch", expanded_url: "https://example.com/fetch"}
        end
      end
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:text] = "primary https://t.co/primary"
      attrs[:message_create][:message_data][:entities][:urls] = urls_class.new

      event = Twitter::DirectMessageEvent.new(attrs)

      assert_equal("primary https://example.com/primary", event.direct_message.text)
    end

    it "does not expand URLs when none are present" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:text] = "no links here"
      attrs[:message_create][:message_data][:entities][:urls] = []

      event = Twitter::DirectMessageEvent.new(attrs)

      assert_equal("no links here", event.direct_message.text)
    end

    it "raises TypeError when the URL hash is missing :url" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:entities][:urls] = [{expanded_url: "https://example.com/primary"}]

      assert_raises(TypeError) do
        Twitter::DirectMessageEvent.new(attrs)
      end
    end

    it "raises TypeError when the URL hash is missing :expanded_url" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:entities][:urls] = [{url: "https://t.co/primary"}]

      assert_raises(TypeError) do
        Twitter::DirectMessageEvent.new(attrs)
      end
    end
  end

  describe "private helpers" do
    it "returns the input hash unchanged when :event is missing" do
      event = Twitter::DirectMessageEvent.allocate

      assert_equal(event_attrs, event.send(:read_from_response, event_attrs))
    end

    it "returns the nested :event hash when present" do
      event = Twitter::DirectMessageEvent.allocate

      assert_equal(event_attrs, event.send(:read_from_response, {event: event_attrs}))
    end

    it "uses [] access when reading wrapped :event data from hash-like inputs" do
      hash_like_attrs_class = Class.new do
        def [](key)
          return nil unless key == :event

          {id: "1006278767680131076", created_timestamp: "1528750528627", message_create: {target: {recipient_id: "1"}, sender_id: "2", message_data: {text: "hello", entities: {urls: []}}}}
        end

        def fetch(_key)
          raise KeyError, "fetch should not be used"
        end
      end
      event = Twitter::DirectMessageEvent.allocate

      parsed = event.send(:read_from_response, hash_like_attrs_class.new)

      assert_equal("1006278767680131076", parsed[:id])
    end

    it "builds a normalized direct message hash with converted ids and timestamp" do
      event = Twitter::DirectMessageEvent.allocate
      text = "normalized text"

      built = event.send(:build_direct_message, event_attrs, text)

      assert_equal(%i[id created_at sender sender_id recipient recipient_id text], built.keys)
      assert_equal(1_006_278_767_680_131_076, built[:id])
      assert_equal(Time.at(1_528_750_528_627 / 1000.0), built[:created_at])
      assert_equal({id: 124_294_236}, built[:sender])
      assert_equal(124_294_236, built[:sender_id])
      assert_equal({id: 58_983}, built[:recipient])
      assert_equal(58_983, built[:recipient_id])
      assert_equal("normalized text", built[:text])
    end
  end
end
