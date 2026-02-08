require "helper"

describe Twitter::DirectMessages::WelcomeMessageWrapper do
  let(:attrs) do
    {
      id: "1073273784206012421",
      created_timestamp: "1544723385274",
      name: "welcome_message_name",
      message_data: {
        text: "first https://t.co/one second https://t.co/two",
        entities: {
          hashtags: [],
          symbols: [],
          user_mentions: [],
          urls: [
            {url: "https://t.co/one", expanded_url: "https://example.com/one"},
            {url: "https://t.co/two", expanded_url: "https://example.com/two"},
          ],
        },
      },
    }
  end

  it "builds a typed welcome_message object from flat attributes" do
    wrapper = described_class.new(attrs)
    message = wrapper.welcome_message

    expect(message).to be_a(Twitter::DirectMessages::WelcomeMessage)
    expect(message.id).to eq(1_073_273_784_206_012_421)
    expect(message.created_at).to eq(Time.at(1_544_723_385_274 / 1000.0))
    expect(message.name).to eq("welcome_message_name")
    expect(message.text).to eq("first https://example.com/one second https://t.co/two")
  end

  it "accepts wrapped response format" do
    wrapper = described_class.new(welcome_message: attrs)

    expect(wrapper.welcome_message.id).to eq(1_073_273_784_206_012_421)
    expect(wrapper.welcome_message.text).to eq("first https://example.com/one second https://t.co/two")
  end

  it "expands every occurrence of the first URL mapping" do
    attrs_with_repeated_url = Marshal.load(Marshal.dump(attrs))
    attrs_with_repeated_url[:message_data][:text] = "repeat https://t.co/one and https://t.co/one"
    attrs_with_repeated_url[:message_data][:entities][:urls] = [
      {url: "https://t.co/one", expanded_url: "https://example.com/one"},
    ]

    wrapper = described_class.new(attrs_with_repeated_url)

    expect(wrapper.welcome_message.text).to eq("repeat https://example.com/one and https://example.com/one")
  end

  it "does not expand URLs when the URL list is empty" do
    attrs_with_no_urls = Marshal.load(Marshal.dump(attrs))
    attrs_with_no_urls[:message_data][:text] = "welcome"
    attrs_with_no_urls[:message_data][:entities][:urls] = []

    wrapper = described_class.new(attrs_with_no_urls)
    expect(wrapper.welcome_message.text).to eq("welcome")
  end

  it "allows missing name values" do
    unnamed_attrs = Marshal.load(Marshal.dump(attrs))
    unnamed_attrs.delete(:name)

    wrapper = described_class.new(unnamed_attrs)
    expect(wrapper.welcome_message.name).to be_nil
  end

  describe "private helpers" do
    it "builds a normalized welcome message hash" do
      wrapper = described_class.allocate
      message_data = attrs.fetch(:message_data)
      text = "normalized text"

      built = wrapper.send(:build_welcome_message, attrs, text, message_data)

      expect(built.keys).to eq([:id, :created_at, :text, :name, :entities])
      expect(built[:id]).to eq(1_073_273_784_206_012_421)
      expect(built[:created_at]).to eq(Time.at(1_544_723_385_274 / 1000.0))
      expect(built[:text]).to eq("normalized text")
      expect(built[:name]).to eq("welcome_message_name")
      expect(built[:entities]).to eq(message_data.fetch(:entities))
    end
  end
end
