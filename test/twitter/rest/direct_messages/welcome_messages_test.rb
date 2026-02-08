require "test_helper"

describe Twitter::REST::DirectMessages::WelcomeMessages do
  before do
    @client = build_rest_client
    @client.define_singleton_method(:user_id) { 22_095_868 }
  end

  describe "Welcome Messages" do
    describe "#create_welcome_message" do
      before do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message.json"), headers: json_headers)
      end

      it "requests the correct resource with proper JSON body" do
        @client.create_welcome_message("Welcome message text")

        assert_requested(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"Welcome message text"}}}'))
      end

      it "returns the created welcome message" do
        welcome_message = @client.create_welcome_message("Welcome message text")

        assert_kind_of(Twitter::DirectMessages::WelcomeMessage, welcome_message)
        assert_equal("Welcome message text", welcome_message.text)
        assert_equal(1_073_273_784_206_012_421, welcome_message.id)
      end

      it "returns created_at as a Time object with correct timestamp" do
        welcome_message = @client.create_welcome_message("Welcome message text")

        assert_kind_of(Time, welcome_message.created_at)
        assert_equal(Time.at(1_544_723_385_274 / 1000.0).utc, welcome_message.created_at)
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {quick_reply_options: [{label: "Option 1"}]}
        options_copy = options.dup
        @client.create_welcome_message("text", nil, options)

        assert_equal(options_copy, options)
        assert_requested(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"quick_reply_options":[{"label":"Option 1"}],"welcome_message":{"message_data":{"text":"text"}}}'))
      end

      it "includes the name in JSON body when provided" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_name.json"), headers: json_headers)
        @client.create_welcome_message("A second welcome message with a name", "welcome_message_name")

        assert_requested(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"A second welcome message with a name"},"name":"welcome_message_name"}}'))
      end

      it "does not include name in JSON body when name is nil" do
        @client.create_welcome_message("Welcome message text", nil)

        assert_requested(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"Welcome message text"}}}'))
      end

      it "can set the welcome message name" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_name.json"), headers: json_headers)

        welcome_message = @client.create_welcome_message("A second welcome message with a name", "welcome_message_name")

        assert_kind_of(Twitter::DirectMessages::WelcomeMessage, welcome_message)
        assert_equal("A second welcome message with a name", welcome_message.text)
        assert_equal(1_073_276_982_106_996_741, welcome_message.id)
        assert_equal("welcome_message_name", welcome_message.name)
      end

      it "sets the entities" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_entities.json"), headers: json_headers)
        welcome_message = @client.create_welcome_message("Url: http://example.com/expanded and #hashtag and @TwitterSupport")

        assert_kind_of(Array, welcome_message.hashtags)
        assert_kind_of(Twitter::Entity::Hashtag, welcome_message.hashtags.first)
        assert_equal([33, 41], welcome_message.hashtags.first.indices)
        assert_equal("hashtag", welcome_message.hashtags.first.text)
        assert_kind_of(Array, welcome_message.user_mentions)
        assert_kind_of(Twitter::Entity::UserMention, welcome_message.user_mentions.first)
        assert_equal([46, 61], welcome_message.user_mentions.first.indices)
        assert_equal(17_874_544, welcome_message.user_mentions.first.id)
        assert_equal("Twitter Support", welcome_message.user_mentions.first.name)
        assert_kind_of(Array, welcome_message.uris)
        assert_kind_of(Twitter::Entity::URI, welcome_message.uris.first)
        assert_equal([5, 28], welcome_message.uris.first.indices)
        assert_equal("example.com/expanded", welcome_message.uris.first.display_url)
      end

      it "substitutes t.co URLs with expanded URLs in text" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_entities.json"), headers: json_headers)
        welcome_message = @client.create_welcome_message("Url: http://example.com/expanded and #hashtag and @TwitterSupport")

        assert_equal("Url: http://example.com/expanded and #hashtag and @TwitterSupport", welcome_message.text)
        refute_includes(welcome_message.text, "https://t.co/")
      end
    end

    describe "#destroy_welcome_message" do
      before do
        stub_delete("/1.1/direct_messages/welcome_messages/destroy.json?id=1073273784206012421").to_return(status: 204, body: "", headers: json_headers)
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message(1_073_273_784_206_012_421)

        assert_requested(a_delete("/1.1/direct_messages/welcome_messages/destroy.json?id=1073273784206012421"))
      end

      it "returns nil" do
        response = @client.destroy_welcome_message(1_073_273_784_206_012_421)

        assert_nil(response)
      end
    end

    describe "#update_welcome_message" do
      before do
        stub_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: json_headers)
      end

      it "requests the correct resource with proper JSON body" do
        @client.update_welcome_message(1_073_273_784_206_012_421, "Welcome message text")

        assert_requested(a_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").with(body: '{"message_data":{"text":"Welcome message text"}}'))
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {attachment: {type: "media"}}
        options_copy = options.dup
        @client.update_welcome_message(1_073_273_784_206_012_421, "text", options)

        assert_equal(options_copy, options)
        assert_requested(a_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").with(body: '{"attachment":{"type":"media"},"message_data":{"text":"text"}}'))
      end

      it "returns the updated welcome message" do
        welcome_message = @client.update_welcome_message(1_073_273_784_206_012_421, "Welcome message text")

        assert_kind_of(Twitter::DirectMessages::WelcomeMessage, welcome_message)
        assert_equal("Welcome message text", welcome_message.text)
        assert_equal(1_073_273_784_206_012_421, welcome_message.id)
      end
    end

    describe "#welcome_message" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.welcome_message(1_073_273_784_206_012_421)

        assert_requested(a_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421"))
      end

      it "does not mutate the passed options hash and passes them to the request" do
        options = {custom: "option"}
        options_copy = options.dup
        stub_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421&custom=option").to_return(body: fixture("welcome_message.json"), headers: json_headers)
        @client.welcome_message(1_073_273_784_206_012_421, options)

        assert_equal(options_copy, options)
        assert_requested(a_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421&custom=option"))
      end

      it "returns the requested welcome message" do
        welcome_message = @client.welcome_message(1_073_273_784_206_012_421)

        assert_kind_of(Twitter::DirectMessages::WelcomeMessage, welcome_message)
        assert_equal("Welcome message text", welcome_message.text)
        assert_equal(1_073_273_784_206_012_421, welcome_message.id)
      end
    end

    describe "#welcome_message_list" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/list.json?count=50").to_return(body: fixture("welcome_messages.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.welcome_message_list

        assert_requested(a_get("/1.1/direct_messages/welcome_messages/list.json?count=50"))
      end

      it "returns the welcome message list" do
        welcome_messages = @client.welcome_message_list

        assert_kind_of(Array, welcome_messages)
        assert_equal(2, welcome_messages.size)
        assert_kind_of(Twitter::DirectMessages::WelcomeMessage, welcome_messages.first)
        assert_equal("Welcome message text updated", welcome_messages.first.text)
        assert_equal(1_073_273_784_206_012_421, welcome_messages.first.id)
      end

      it "passes a default limit of 20 without mutating caller options" do
        wrapper = Object.new
        wrapper.define_singleton_method(:welcome_message) { :message }
        options = {}
        called = false

        @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
          called = true

          assert_equal("/1.1/direct_messages/welcome_messages/list.json", path)
          assert_equal({no_default_cursor: true, count: 50, limit: 20}, opts)
          assert_equal(:welcome_messages, key)
          assert_equal(Twitter::DirectMessages::WelcomeMessageWrapper, wrapper_class)
          [wrapper]
        }) do
          assert_equal([:message], @client.welcome_message_list(options))
        end
        assert(called)
        assert_empty(options)
      end

      it "uses options[:count] for limit and preserves custom caller options" do
        wrapper = Object.new
        wrapper.define_singleton_method(:welcome_message) { :message }
        options = {count: 1, cursor: "cursor-1"}
        called = false
        @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
          called = true

          assert_equal("/1.1/direct_messages/welcome_messages/list.json", path)
          assert_equal({count: 50, cursor: "cursor-1", no_default_cursor: true, limit: 1}, opts)
          assert_equal(:welcome_messages, key)
          assert_equal(Twitter::DirectMessages::WelcomeMessageWrapper, wrapper_class)
          [wrapper]
        }) do
          @client.welcome_message_list(options)
        end

        assert(called)
        assert_equal({count: 1, cursor: "cursor-1"}, options)
      end
    end
  end

  describe "Welcome Message Rules" do
    describe "#create_welcome_message_rule" do
      before do
        stub_post("/1.1/direct_messages/welcome_messages/rules/new.json").to_return(body: fixture("welcome_message_rule.json"), headers: json_headers)
      end

      it "requests the correct resource with proper JSON body" do
        @client.create_welcome_message_rule(1_073_273_784_206_012_421)

        assert_requested(a_post("/1.1/direct_messages/welcome_messages/rules/new.json").with(body: '{"welcome_message_rule":{"welcome_message_id":1073273784206012421}}'))
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {is_default: true}
        options_copy = options.dup
        @client.create_welcome_message_rule(1_073_273_784_206_012_421, options)

        assert_equal(options_copy, options)
        assert_requested(a_post("/1.1/direct_messages/welcome_messages/rules/new.json").with(body: '{"is_default":true,"welcome_message_rule":{"welcome_message_id":1073273784206012421}}'))
      end

      it "returns the created welcome message rule" do
        welcome_message_rule = @client.create_welcome_message_rule(1_073_273_784_206_012_421)

        assert_kind_of(Twitter::DirectMessages::WelcomeMessageRule, welcome_message_rule)
        assert_equal(1_073_279_057_817_731_072, welcome_message_rule.id)
        assert_equal(1_073_273_784_206_012_421, welcome_message_rule.welcome_message_id)
      end
    end

    describe "#destroy_welcome_message_rule" do
      before do
        stub_delete("/1.1/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072").to_return(status: 204, body: "", headers: json_headers)
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)

        assert_requested(a_delete("/1.1/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072"))
      end

      it "returns nil" do
        response = @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)

        assert_nil(response)
      end
    end

    describe "#welcome_message_rule" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072").to_return(body: fixture("welcome_message_rule.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.welcome_message_rule(1_073_279_057_817_731_072)

        assert_requested(a_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072"))
      end

      it "does not mutate the passed options hash and passes them to the request" do
        options = {custom: "option"}
        options_copy = options.dup
        stub_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072&custom=option").to_return(body: fixture("welcome_message_rule.json"), headers: json_headers)
        @client.welcome_message_rule(1_073_279_057_817_731_072, options)

        assert_equal(options_copy, options)
        assert_requested(a_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072&custom=option"))
      end

      it "returns the requested welcome message rule" do
        welcome_message_rule = @client.welcome_message_rule(1_073_279_057_817_731_072)

        assert_kind_of(Twitter::DirectMessages::WelcomeMessageRule, welcome_message_rule)
        assert_equal(1_073_279_057_817_731_072, welcome_message_rule.id)
        assert_equal(1_073_273_784_206_012_421, welcome_message_rule.welcome_message_id)
      end
    end

    describe "#welcome_message_rule_list" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/rules/list.json?count=50").to_return(body: fixture("welcome_message_rules.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.welcome_message_rule_list

        assert_requested(a_get("/1.1/direct_messages/welcome_messages/rules/list.json?count=50"))
      end

      it "returns the welcome message rule list" do
        welcome_message_rules = @client.welcome_message_rule_list

        assert_kind_of(Array, welcome_message_rules)
        assert_equal(1, welcome_message_rules.size)
        assert_kind_of(Twitter::DirectMessages::WelcomeMessageRule, welcome_message_rules.first)
        assert_equal(1_073_279_057_817_731_072, welcome_message_rules.first.id)
        assert_equal(1_073_273_784_206_012_421, welcome_message_rules.first.welcome_message_id)
      end

      it "passes a default limit of 20 without mutating caller options" do
        wrapper = Object.new
        wrapper.define_singleton_method(:welcome_message_rule) { :rule }
        options = {}
        called = false

        @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
          called = true

          assert_equal("/1.1/direct_messages/welcome_messages/rules/list.json", path)
          assert_equal({no_default_cursor: true, count: 50, limit: 20}, opts)
          assert_equal(:welcome_message_rules, key)
          assert_equal(Twitter::DirectMessages::WelcomeMessageRuleWrapper, wrapper_class)
          [wrapper]
        }) do
          assert_equal([:rule], @client.welcome_message_rule_list(options))
        end
        assert(called)
        assert_empty(options)
      end

      it "uses options[:count] for limit and preserves custom caller options" do
        wrapper = Object.new
        wrapper.define_singleton_method(:welcome_message_rule) { :rule }
        options = {count: 1, cursor: "cursor-2"}
        called = false
        @client.stub(:perform_get_with_cursor, lambda { |path, opts, key, wrapper_class|
          called = true

          assert_equal("/1.1/direct_messages/welcome_messages/rules/list.json", path)
          assert_equal({count: 50, cursor: "cursor-2", no_default_cursor: true, limit: 1}, opts)
          assert_equal(:welcome_message_rules, key)
          assert_equal(Twitter::DirectMessages::WelcomeMessageRuleWrapper, wrapper_class)
          [wrapper]
        }) do
          @client.welcome_message_rule_list(options)
        end

        assert(called)
        assert_equal({count: 1, cursor: "cursor-2"}, options)
      end
    end
  end
end

# Include wrapper constants in wrapper coverage mapping for this spec file.
describe Twitter::DirectMessages::WelcomeMessageWrapper do
end

describe Twitter::DirectMessages::WelcomeMessageRuleWrapper do
end
