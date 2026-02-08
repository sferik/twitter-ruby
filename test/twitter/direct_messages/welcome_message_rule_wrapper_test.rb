require "test_helper"

describe Twitter::DirectMessages::WelcomeMessageRuleWrapper do
  let(:attrs) do
    {
      id: "1073279057817731072",
      created_timestamp: "1544724642601",
      welcome_message_id: "1073273784206012421"
    }
  end

  describe "#initialize" do
    it "builds a typed welcome_message_rule object from flat attributes" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.new(attrs)
      rule = wrapper.welcome_message_rule

      assert_kind_of(Twitter::DirectMessages::WelcomeMessageRule, rule)
      assert_equal(1_073_279_057_817_731_072, rule.id)
      assert_equal(1_073_273_784_206_012_421, rule.welcome_message_id)
      assert_equal(Time.at(1_544_724_642_601 / 1000.0), rule.created_at)
    end

    it "accepts wrapped response format" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.new(welcome_message_rule: attrs)

      assert_equal(1_073_279_057_817_731_072, wrapper.welcome_message_rule.id)
      assert_equal(1_073_273_784_206_012_421, wrapper.welcome_message_rule.welcome_message_id)
    end
  end

  describe "private parsing behavior" do
    it "builds exactly id, created_at, and welcome_message_id from the passed attrs" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.allocate
      parsed = wrapper.send(:build_welcome_message_rule, attrs)

      assert_equal({
        id: 1_073_279_057_817_731_072,
        created_at: Time.at(1_544_724_642_601 / 1000.0),
        welcome_message_id: 1_073_273_784_206_012_421
      }, parsed)
    end

    it "coerces nil values consistently" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.allocate
      parsed = wrapper.send(:build_welcome_message_rule, {id: nil, created_timestamp: nil, welcome_message_id: nil})

      assert_equal({
        id: 0,
        created_at: Time.at(0.0),
        welcome_message_id: 0
      }, parsed)
    end

    it "coerces missing keys consistently" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.allocate
      parsed = wrapper.send(:build_welcome_message_rule, {})

      assert_equal({
        id: 0,
        created_at: Time.at(0.0),
        welcome_message_id: 0
      }, parsed)
    end

    it "uses [] access when extracting wrapped response data" do
      hash_like_attrs_class = Class.new do
        def [](key)
          return nil unless key == :welcome_message_rule

          {
            id: "1",
            created_timestamp: "1000",
            welcome_message_id: "2"
          }
        end

        def fetch(_key)
          raise KeyError, "fetch should not be used"
        end
      end
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.new(hash_like_attrs_class.new)

      assert_equal(1, wrapper.welcome_message_rule.id)
      assert_equal(2, wrapper.welcome_message_rule.welcome_message_id)
    end
  end
end
