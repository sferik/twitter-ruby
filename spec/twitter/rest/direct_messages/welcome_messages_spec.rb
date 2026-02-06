require "helper"

describe Twitter::REST::DirectMessages::WelcomeMessages do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    allow(@client).to receive(:user_id).and_return(22_095_868)
  end

  context "Welcome Messages" do
    describe "#create_welcome_message" do
      before do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource with proper JSON body" do
        @client.create_welcome_message("Welcome message text")
        expect(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"Welcome message text"}}}')).to have_been_made
      end

      it "returns the created welcome message" do
        welcome_message = @client.create_welcome_message("Welcome message text")
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("Welcome message text")
        expect(welcome_message.id).to eq(1_073_273_784_206_012_421)
      end

      it "returns created_at as a Time object with correct timestamp" do
        welcome_message = @client.create_welcome_message("Welcome message text")
        expect(welcome_message.created_at).to be_a(Time)
        expect(welcome_message.created_at).to eq(Time.at(1_544_723_385_274 / 1000.0).utc)
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {quick_reply_options: [{label: "Option 1"}]}
        options_copy = options.dup
        @client.create_welcome_message("text", nil, options)
        expect(options).to eq(options_copy)
        expect(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"quick_reply_options":[{"label":"Option 1"}],"welcome_message":{"message_data":{"text":"text"}}}')).to have_been_made
      end

      it "includes the name in JSON body when provided" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_name.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.create_welcome_message("A second welcome message with a name", "welcome_message_name")
        expect(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"A second welcome message with a name"},"name":"welcome_message_name"}}')).to have_been_made
      end

      it "does not include name in JSON body when name is nil" do
        @client.create_welcome_message("Welcome message text", nil)
        expect(a_post("/1.1/direct_messages/welcome_messages/new.json").with(body: '{"welcome_message":{"message_data":{"text":"Welcome message text"}}}')).to have_been_made
      end

      it "can set the welcome message name" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_name.json"), headers: {content_type: "application/json; charset=utf-8"})

        welcome_message = @client.create_welcome_message("A second welcome message with a name", "welcome_message_name")
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("A second welcome message with a name")
        expect(welcome_message.id).to eq(1_073_276_982_106_996_741)
        expect(welcome_message.name).to eq("welcome_message_name")
      end

      it "sets the entities" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_entities.json"), headers: {content_type: "application/json; charset=utf-8"})
        welcome_message = @client.create_welcome_message("Url: http://example.com/expanded and #hashtag and @TwitterSupport")
        expect(welcome_message.hashtags).to be_an(Array)
        expect(welcome_message.hashtags.first).to be_a(Twitter::Entity::Hashtag)
        expect(welcome_message.hashtags.first.indices).to eq([33, 41])
        expect(welcome_message.hashtags.first.text).to eq("hashtag")
        expect(welcome_message.user_mentions).to be_an(Array)
        expect(welcome_message.user_mentions.first).to be_a(Twitter::Entity::UserMention)
        expect(welcome_message.user_mentions.first.indices).to eq([46, 61])
        expect(welcome_message.user_mentions.first.id).to eq(17_874_544)
        expect(welcome_message.user_mentions.first.name).to eq("Twitter Support")
        expect(welcome_message.uris).to be_an(Array)
        expect(welcome_message.uris.first).to be_a(Twitter::Entity::URI)
        expect(welcome_message.uris.first.indices).to eq([5, 28])
        expect(welcome_message.uris.first.display_url).to eq("example.com/expanded")
      end

      it "substitutes t.co URLs with expanded URLs in text" do
        stub_post("/1.1/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_entities.json"), headers: {content_type: "application/json; charset=utf-8"})
        welcome_message = @client.create_welcome_message("Url: http://example.com/expanded and #hashtag and @TwitterSupport")
        expect(welcome_message.text).to eq("Url: http://example.com/expanded and #hashtag and @TwitterSupport")
        expect(welcome_message.text).not_to include("https://t.co/")
      end
    end

    describe "#destroy_welcome_message" do
      before do
        stub_delete("/1.1/direct_messages/welcome_messages/destroy.json?id=1073273784206012421").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message(1_073_273_784_206_012_421)
        expect(a_delete("/1.1/direct_messages/welcome_messages/destroy.json?id=1073273784206012421")).to have_been_made
      end

      it "returns nil" do
        response = @client.destroy_welcome_message(1_073_273_784_206_012_421)
        expect(response).to be_nil
      end
    end

    describe "#update_welcome_message" do
      before do
        stub_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource with proper JSON body" do
        @client.update_welcome_message(1_073_273_784_206_012_421, "Welcome message text")
        expect(a_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").with(body: '{"message_data":{"text":"Welcome message text"}}')).to have_been_made
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {attachment: {type: "media"}}
        options_copy = options.dup
        @client.update_welcome_message(1_073_273_784_206_012_421, "text", options)
        expect(options).to eq(options_copy)
        expect(a_put("/1.1/direct_messages/welcome_messages/update.json?id=1073273784206012421").with(body: '{"attachment":{"type":"media"},"message_data":{"text":"text"}}')).to have_been_made
      end

      it "returns the updated welcome message" do
        welcome_message = @client.update_welcome_message(1_073_273_784_206_012_421, "Welcome message text")
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("Welcome message text")
        expect(welcome_message.id).to eq(1_073_273_784_206_012_421)
      end
    end

    describe "#welcome_message" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message(1_073_273_784_206_012_421)
        expect(a_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421")).to have_been_made
      end

      it "does not mutate the passed options hash and passes them to the request" do
        options = {custom: "option"}
        options_copy = options.dup
        stub_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421&custom=option").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.welcome_message(1_073_273_784_206_012_421, options)
        expect(options).to eq(options_copy)
        expect(a_get("/1.1/direct_messages/welcome_messages/show.json?id=1073273784206012421&custom=option")).to have_been_made
      end

      it "returns the requested welcome message" do
        welcome_message = @client.welcome_message(1_073_273_784_206_012_421)
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("Welcome message text")
        expect(welcome_message.id).to eq(1_073_273_784_206_012_421)
      end
    end

    describe "#welcome_message_list" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/list.json?count=50").to_return(body: fixture("welcome_messages.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_list
        expect(a_get("/1.1/direct_messages/welcome_messages/list.json?count=50")).to have_been_made
      end

      it "returns the welcome message list" do
        welcome_messages = @client.welcome_message_list
        expect(welcome_messages).to be_an Array
        expect(welcome_messages.size).to eq 2
        expect(welcome_messages.first).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_messages.first.text).to eq("Welcome message text updated")
        expect(welcome_messages.first.id).to eq(1_073_273_784_206_012_421)
      end

      it "passes a default limit of 20 without mutating caller options" do
        wrapper = instance_double(Twitter::DirectMessages::WelcomeMessageWrapper, welcome_message: :message)
        options = {}
        expect(@client).to receive(:perform_get_with_cursor)
          .with("/1.1/direct_messages/welcome_messages/list.json", {no_default_cursor: true, count: 50, limit: 20}, :welcome_messages, Twitter::DirectMessages::WelcomeMessageWrapper)
          .and_return([wrapper])

        expect(@client.welcome_message_list(options)).to eq([:message])
        expect(options).to eq({})
      end

      it "uses options[:count] for limit and preserves custom caller options" do
        wrapper = instance_double(Twitter::DirectMessages::WelcomeMessageWrapper, welcome_message: :message)
        options = {count: 1, cursor: "cursor-1"}
        expect(@client).to receive(:perform_get_with_cursor)
          .with("/1.1/direct_messages/welcome_messages/list.json", {count: 50, cursor: "cursor-1", no_default_cursor: true, limit: 1}, :welcome_messages, Twitter::DirectMessages::WelcomeMessageWrapper)
          .and_return([wrapper])

        @client.welcome_message_list(options)
        expect(options).to eq({count: 1, cursor: "cursor-1"})
      end
    end
  end

  context "Welcome Message Rules" do
    describe "#create_welcome_message_rule" do
      before do
        stub_post("/1.1/direct_messages/welcome_messages/rules/new.json").to_return(body: fixture("welcome_message_rule.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource with proper JSON body" do
        @client.create_welcome_message_rule(1_073_273_784_206_012_421)
        expect(a_post("/1.1/direct_messages/welcome_messages/rules/new.json").with(body: '{"welcome_message_rule":{"welcome_message_id":1073273784206012421}}')).to have_been_made
      end

      it "does not mutate the passed options hash and includes them in request" do
        options = {is_default: true}
        options_copy = options.dup
        @client.create_welcome_message_rule(1_073_273_784_206_012_421, options)
        expect(options).to eq(options_copy)
        expect(a_post("/1.1/direct_messages/welcome_messages/rules/new.json").with(body: '{"is_default":true,"welcome_message_rule":{"welcome_message_id":1073273784206012421}}')).to have_been_made
      end

      it "returns the created welcome message rule" do
        welcome_message_rule = @client.create_welcome_message_rule(1_073_273_784_206_012_421)
        expect(welcome_message_rule).to be_a Twitter::DirectMessages::WelcomeMessageRule
        expect(welcome_message_rule.id).to eq(1_073_279_057_817_731_072)
        expect(welcome_message_rule.welcome_message_id).to eq(1_073_273_784_206_012_421)
      end
    end

    describe "#destroy_welcome_message_rule" do
      before do
        stub_delete("/1.1/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)
        expect(a_delete("/1.1/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072")).to have_been_made
      end

      it "returns nil" do
        response = @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)
        expect(response).to be_nil
      end
    end

    describe "#welcome_message_rule" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072").to_return(body: fixture("welcome_message_rule.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_rule(1_073_279_057_817_731_072)
        expect(a_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072")).to have_been_made
      end

      it "does not mutate the passed options hash and passes them to the request" do
        options = {custom: "option"}
        options_copy = options.dup
        stub_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072&custom=option").to_return(body: fixture("welcome_message_rule.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.welcome_message_rule(1_073_279_057_817_731_072, options)
        expect(options).to eq(options_copy)
        expect(a_get("/1.1/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072&custom=option")).to have_been_made
      end

      it "returns the requested welcome message rule" do
        welcome_message_rule = @client.welcome_message_rule(1_073_279_057_817_731_072)
        expect(welcome_message_rule).to be_a Twitter::DirectMessages::WelcomeMessageRule
        expect(welcome_message_rule.id).to eq(1_073_279_057_817_731_072)
        expect(welcome_message_rule.welcome_message_id).to eq(1_073_273_784_206_012_421)
      end
    end

    describe "#welcome_message_rule_list" do
      before do
        stub_get("/1.1/direct_messages/welcome_messages/rules/list.json?count=50").to_return(body: fixture("welcome_message_rules.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_rule_list
        expect(a_get("/1.1/direct_messages/welcome_messages/rules/list.json?count=50")).to have_been_made
      end

      it "returns the welcome message rule list" do
        welcome_message_rules = @client.welcome_message_rule_list
        expect(welcome_message_rules).to be_an Array
        expect(welcome_message_rules.size).to eq 1
        expect(welcome_message_rules.first).to be_a Twitter::DirectMessages::WelcomeMessageRule
        expect(welcome_message_rules.first.id).to eq(1_073_279_057_817_731_072)
        expect(welcome_message_rules.first.welcome_message_id).to eq(1_073_273_784_206_012_421)
      end

      it "passes a default limit of 20 without mutating caller options" do
        wrapper = instance_double(Twitter::DirectMessages::WelcomeMessageRuleWrapper, welcome_message_rule: :rule)
        options = {}
        expect(@client).to receive(:perform_get_with_cursor)
          .with("/1.1/direct_messages/welcome_messages/rules/list.json", {no_default_cursor: true, count: 50, limit: 20}, :welcome_message_rules, Twitter::DirectMessages::WelcomeMessageRuleWrapper)
          .and_return([wrapper])

        expect(@client.welcome_message_rule_list(options)).to eq([:rule])
        expect(options).to eq({})
      end

      it "uses options[:count] for limit and preserves custom caller options" do
        wrapper = instance_double(Twitter::DirectMessages::WelcomeMessageRuleWrapper, welcome_message_rule: :rule)
        options = {count: 1, cursor: "cursor-2"}
        expect(@client).to receive(:perform_get_with_cursor)
          .with("/1.1/direct_messages/welcome_messages/rules/list.json", {count: 50, cursor: "cursor-2", no_default_cursor: true, limit: 1}, :welcome_message_rules, Twitter::DirectMessages::WelcomeMessageRuleWrapper)
          .and_return([wrapper])

        @client.welcome_message_rule_list(options)
        expect(options).to eq({count: 1, cursor: "cursor-2"})
      end
    end
  end
end

# Include wrapper constants in wrapper coverage mapping for this spec file.
describe Twitter::DirectMessages::WelcomeMessageWrapper do
end

describe Twitter::DirectMessages::WelcomeMessageRuleWrapper do
end
