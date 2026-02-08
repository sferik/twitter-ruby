require "helper"

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
      event = described_class.new(event: event_attrs)

      expect(event.id).to eq("1006278767680131076")
      expect(event.direct_message.id).to eq(1_006_278_767_680_131_076)
      expect(event.direct_message.sender_id).to eq(124_294_236)
      expect(event.direct_message.recipient_id).to eq(58_983)
    end

    it "accepts unwrapped responses and expands the first URL mapping" do
      event = described_class.new(event_attrs)

      expect(event.direct_message.text).to eq("first https://example.com/one second https://t.co/two")
    end

    it "expands every occurrence of the first URL mapping" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:text] = "repeat https://t.co/one and https://t.co/one"
      attrs[:message_create][:message_data][:entities][:urls] = [
        {url: "https://t.co/one", expanded_url: "https://example.com/one"}
      ]

      event = described_class.new(attrs)

      expect(event.direct_message.text).to eq("repeat https://example.com/one and https://example.com/one")
    end

    it "raises NoMethodError when message_create is missing" do
      expect do
        described_class.new(id: "1", created_timestamp: "1")
      end.to raise_error(NoMethodError)
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

      event = described_class.new(attrs)
      expect(event.direct_message.text).to eq("primary https://example.com/primary")
    end

    it "does not expand URLs when none are present" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:text] = "no links here"
      attrs[:message_create][:message_data][:entities][:urls] = []

      event = described_class.new(attrs)
      expect(event.direct_message.text).to eq("no links here")
    end

    it "raises TypeError when the URL hash is missing :url" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:entities][:urls] = [{expanded_url: "https://example.com/primary"}]

      expect do
        described_class.new(attrs)
      end.to raise_error(TypeError)
    end

    it "raises TypeError when the URL hash is missing :expanded_url" do
      attrs = Marshal.load(Marshal.dump(event_attrs))
      attrs[:message_create][:message_data][:entities][:urls] = [{url: "https://t.co/primary"}]

      expect do
        described_class.new(attrs)
      end.to raise_error(TypeError)
    end
  end

  describe "private helpers" do
    it "returns the input hash unchanged when :event is missing" do
      event = described_class.allocate

      expect(event.send(:read_from_response, event_attrs)).to eq(event_attrs)
    end

    it "returns the nested :event hash when present" do
      event = described_class.allocate

      expect(event.send(:read_from_response, {event: event_attrs})).to eq(event_attrs)
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
      event = described_class.allocate

      parsed = event.send(:read_from_response, hash_like_attrs_class.new)
      expect(parsed[:id]).to eq("1006278767680131076")
    end

    it "builds a normalized direct message hash with converted ids and timestamp" do
      event = described_class.allocate
      text = "normalized text"

      built = event.send(:build_direct_message, event_attrs, text)

      expect(built.keys).to eq(%i[id created_at sender sender_id recipient recipient_id text])
      expect(built[:id]).to eq(1_006_278_767_680_131_076)
      expect(built[:created_at]).to eq(Time.at(1_528_750_528_627 / 1000.0))
      expect(built[:sender]).to eq({id: 124_294_236})
      expect(built[:sender_id]).to eq(124_294_236)
      expect(built[:recipient]).to eq({id: 58_983})
      expect(built[:recipient_id]).to eq(58_983)
      expect(built[:text]).to eq("normalized text")
    end
  end
end
