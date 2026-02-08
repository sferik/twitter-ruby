require "test_helper"

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
            {url: "https://t.co/two", expanded_url: "https://example.com/two"}
          ]
        }
      }
    }
  end

  it "builds a typed welcome_message object from flat attributes" do
    wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(attrs)
    message = wrapper.welcome_message

    assert_kind_of(Twitter::DirectMessages::WelcomeMessage, message)
    assert_equal(1_073_273_784_206_012_421, message.id)
    assert_equal(Time.at(1_544_723_385_274 / 1000.0), message.created_at)
    assert_equal("welcome_message_name", message.name)
    assert_equal("first https://example.com/one second https://t.co/two", message.text)
  end

  it "accepts wrapped response format" do
    wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(welcome_message: attrs)

    assert_equal(1_073_273_784_206_012_421, wrapper.welcome_message.id)
    assert_equal("first https://example.com/one second https://t.co/two", wrapper.welcome_message.text)
  end

  it "expands every occurrence of the first URL mapping" do
    attrs_with_repeated_url = Marshal.load(Marshal.dump(attrs))
    attrs_with_repeated_url[:message_data][:text] = "repeat https://t.co/one and https://t.co/one"
    attrs_with_repeated_url[:message_data][:entities][:urls] = [
      {url: "https://t.co/one", expanded_url: "https://example.com/one"}
    ]

    wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(attrs_with_repeated_url)

    assert_equal("repeat https://example.com/one and https://example.com/one", wrapper.welcome_message.text)
  end

  it "does not expand URLs when the URL list is empty" do
    attrs_with_no_urls = Marshal.load(Marshal.dump(attrs))
    attrs_with_no_urls[:message_data][:text] = "welcome"
    attrs_with_no_urls[:message_data][:entities][:urls] = []

    wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(attrs_with_no_urls)

    assert_equal("welcome", wrapper.welcome_message.text)
  end

  it "allows missing name values" do
    unnamed_attrs = Marshal.load(Marshal.dump(attrs))
    unnamed_attrs.delete(:name)

    wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(unnamed_attrs)

    assert_nil(wrapper.welcome_message.name)
  end

  describe "private helpers" do
    it "builds a normalized welcome message hash" do
      wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.allocate
      message_data = attrs.fetch(:message_data)
      text = "normalized text"

      built = wrapper.send(:build_welcome_message, attrs, text, message_data)

      assert_equal(%i[id created_at text name entities], built.keys)
      assert_equal(1_073_273_784_206_012_421, built[:id])
      assert_equal(Time.at(1_544_723_385_274 / 1000.0), built[:created_at])
      assert_equal("normalized text", built[:text])
      assert_equal("welcome_message_name", built[:name])
      assert_equal(message_data.fetch(:entities), built[:entities])
    end
  end
end
