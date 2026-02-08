require "helper"

describe Twitter::DirectMessages::WelcomeMessageRuleWrapper do
  let(:attrs) do
    {
      id: "1073279057817731072",
      created_timestamp: "1544724642601",
      welcome_message_id: "1073273784206012421",
    }
  end

  describe "#initialize" do
    it "builds a typed welcome_message_rule object from flat attributes" do
      wrapper = described_class.new(attrs)
      rule = wrapper.welcome_message_rule

      expect(rule).to be_a(Twitter::DirectMessages::WelcomeMessageRule)
      expect(rule.id).to eq(1_073_279_057_817_731_072)
      expect(rule.welcome_message_id).to eq(1_073_273_784_206_012_421)
      expect(rule.created_at).to eq(Time.at(1_544_724_642_601 / 1000.0))
    end

    it "accepts wrapped response format" do
      wrapper = described_class.new(welcome_message_rule: attrs)

      expect(wrapper.welcome_message_rule.id).to eq(1_073_279_057_817_731_072)
      expect(wrapper.welcome_message_rule.welcome_message_id).to eq(1_073_273_784_206_012_421)
    end
  end

  describe "private parsing behavior" do
    it "builds exactly id, created_at, and welcome_message_id from the passed attrs" do
      wrapper = described_class.allocate
      parsed = wrapper.send(:build_welcome_message_rule, attrs)

      expect(parsed).to eq(
        id: 1_073_279_057_817_731_072,
        created_at: Time.at(1_544_724_642_601 / 1000.0),
        welcome_message_id: 1_073_273_784_206_012_421
      )
    end

    it "coerces nil values consistently" do
      wrapper = described_class.allocate
      parsed = wrapper.send(:build_welcome_message_rule, {id: nil, created_timestamp: nil, welcome_message_id: nil})

      expect(parsed).to eq(
        id: 0,
        created_at: Time.at(0.0),
        welcome_message_id: 0
      )
    end

    it "coerces missing keys consistently" do
      wrapper = described_class.allocate
      parsed = wrapper.send(:build_welcome_message_rule, {})

      expect(parsed).to eq(
        id: 0,
        created_at: Time.at(0.0),
        welcome_message_id: 0
      )
    end

    it "uses [] access when extracting wrapped response data" do
      hash_like_attrs_class = Class.new do
        def [](key)
          return nil unless key == :welcome_message_rule

          {
            id: "1",
            created_timestamp: "1000",
            welcome_message_id: "2",
          }
        end

        def fetch(_key)
          raise KeyError, "fetch should not be used"
        end
      end
      wrapper = described_class.new(hash_like_attrs_class.new)

      expect(wrapper.welcome_message_rule.id).to eq(1)
      expect(wrapper.welcome_message_rule.welcome_message_id).to eq(2)
    end
  end
end
