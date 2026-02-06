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
end
