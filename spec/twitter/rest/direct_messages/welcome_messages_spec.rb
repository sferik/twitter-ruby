require "helper"

describe Twitter::REST::DirectMessages::WelcomeMessages do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    allow(@client).to receive(:user_id).and_return(22_095_868)
  end

  context "Welcome Messages" do
    describe "#create_welcome_message" do
      before do
        stub_post("/2/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.create_welcome_message("Welcome message text")
        expect(a_post("/2/direct_messages/welcome_messages/new.json")).to have_been_made
      end

      it "returns the created welcome message" do
        welcome_message = @client.create_welcome_message("Welcome message text")
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("Welcome message text")
        expect(welcome_message.id).to eq(1_073_273_784_206_012_421)
      end

      it "can set the welcome message name" do
        stub_post("/2/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_name.json"), headers: {content_type: "application/json; charset=utf-8"})

        welcome_message = @client.create_welcome_message("A second welcome message with a name", "welcome_message_name")
        expect(welcome_message).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_message.text).to eq("A second welcome message with a name")
        expect(welcome_message.id).to eq(1_073_276_982_106_996_741)
        expect(welcome_message.name).to eq("welcome_message_name")
      end

      it "sets the entities" do
        stub_post("/2/direct_messages/welcome_messages/new.json").to_return(body: fixture("welcome_message_with_entities.json"), headers: {content_type: "application/json; charset=utf-8"})
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
    end

    describe "#destroy_welcome_message" do
      before do
        stub_delete("/2/direct_messages/welcome_messages/destroy.json?id=1073273784206012421").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message(1_073_273_784_206_012_421)
        expect(a_delete("/2/direct_messages/welcome_messages/destroy.json?id=1073273784206012421")).to have_been_made
      end

      it "returns nil" do
        response = @client.destroy_welcome_message(1_073_273_784_206_012_421)
        expect(response).to be_nil
      end
    end

    describe "#update_welcome_message" do
      before do
        stub_put("/2/direct_messages/welcome_messages/update.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update_welcome_message(1_073_273_784_206_012_421, "Welcome message text")
        expect(a_put("/2/direct_messages/welcome_messages/update.json?id=1073273784206012421")).to have_been_made
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
        stub_get("/2/direct_messages/welcome_messages/show.json?id=1073273784206012421").to_return(body: fixture("welcome_message.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message(1_073_273_784_206_012_421)
        expect(a_get("/2/direct_messages/welcome_messages/show.json?id=1073273784206012421")).to have_been_made
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
        stub_get("/2/direct_messages/welcome_messages/list.json?count=50").to_return(body: fixture("welcome_messages.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_list
        expect(a_get("/2/direct_messages/welcome_messages/list.json?count=50")).to have_been_made
      end

      it "returns the welcome message list" do
        welcome_messages = @client.welcome_message_list
        expect(welcome_messages).to be_an Array
        expect(welcome_messages.size).to eq 2
        expect(welcome_messages.first).to be_a Twitter::DirectMessages::WelcomeMessage
        expect(welcome_messages.first.text).to eq("Welcome message text updated")
        expect(welcome_messages.first.id).to eq(1_073_273_784_206_012_421)
      end
    end
  end

  context "Welcome Message Rules" do
    describe "#create_welcome_message_rule" do
      before do
        stub_post("/2/direct_messages/welcome_messages/rules/new.json").to_return(body: fixture("welcome_message_rule.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.create_welcome_message_rule(1_073_273_784_206_012_421)
        expect(a_post("/2/direct_messages/welcome_messages/rules/new.json")).to have_been_made
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
        stub_delete("/2/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072").to_return(status: 204, body: "", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)
        expect(a_delete("/2/direct_messages/welcome_messages/rules/destroy.json?id=1073279057817731072")).to have_been_made
      end

      it "returns nil" do
        response = @client.destroy_welcome_message_rule(1_073_279_057_817_731_072)
        expect(response).to be_nil
      end
    end

    describe "#welcome_message_rule" do
      before do
        stub_get("/2/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072").to_return(body: fixture("welcome_message_rule.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_rule(1_073_279_057_817_731_072)
        expect(a_get("/2/direct_messages/welcome_messages/rules/show.json?id=1073279057817731072")).to have_been_made
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
        stub_get("/2/direct_messages/welcome_messages/rules/list.json?count=50").to_return(body: fixture("welcome_message_rules.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.welcome_message_rule_list
        expect(a_get("/2/direct_messages/welcome_messages/rules/list.json?count=50")).to have_been_made
      end

      it "returns the welcome message rule list" do
        welcome_message_rules = @client.welcome_message_rule_list
        expect(welcome_message_rules).to be_an Array
        expect(welcome_message_rules.size).to eq 1
        expect(welcome_message_rules.first).to be_a Twitter::DirectMessages::WelcomeMessageRule
        expect(welcome_message_rules.first.id).to eq(1_073_279_057_817_731_072)
        expect(welcome_message_rules.first.welcome_message_id).to eq(1_073_273_784_206_012_421)
      end
    end
  end
end
