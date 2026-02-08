require "helper"

describe Twitter::REST::Users do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#settings" do
    before do
      stub_get("/1.1/account/settings.json").to_return(body: fixture("settings.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/account/settings.json").with(body: {trend_location_woeid: "23424803"}).to_return(body: fixture("settings.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    context "on GET" do
      it "requests the correct resource" do
        @client.settings
        expect(a_get("/1.1/account/settings.json")).to have_been_made
      end

      it "returns settings" do
        settings = @client.settings
        expect(settings).to be_a Twitter::Settings
        expect(settings.language).to eq("en")
      end

      it "returns the first trend location from the response array" do
        settings = @client.settings
        expect(settings.trend_location).to be_a Twitter::Place
        expect(settings.trend_location.name).to eq("San Francisco")
        expect(settings.trend_location.woeid).to eq(2_487_956)
      end
    end

    context "when response has no trend_location" do
      before do
        stub_get("/1.1/account/settings.json").to_return(body: '{"language":"en"}', headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns nil for trend_location when not present in response" do
        settings = @client.settings
        expect(settings.trend_location).to be_nil
      end
    end

    context "on POST" do
      it "requests the correct resource" do
        @client.settings(trend_location_woeid: "23424803")
        expect(a_post("/1.1/account/settings.json").with(body: {trend_location_woeid: "23424803"})).to have_been_made
      end

      it "returns settings" do
        settings = @client.settings(trend_location_woeid: "23424803")
        expect(settings).to be_a Twitter::Settings
        expect(settings.language).to eq("en")
      end
    end
  end

  describe "#verify_credentials" do
    before do
      stub_get("/1.1/account/verify_credentials.json").to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.verify_credentials
      expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
    end

    it "returns the requesting user" do
      user = @client.verify_credentials
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe "#update_delivery_device" do
    before do
      stub_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update_delivery_device("sms")
      expect(a_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms"})).to have_been_made
    end

    it "returns a user" do
      user = @client.update_delivery_device("sms")
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end

    context "with options" do
      before do
        stub_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms", include_entities: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options in the request" do
        @client.update_delivery_device("sms", include_entities: true)
        expect(a_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms", include_entities: "true"})).to have_been_made
      end
    end
  end

  describe "#update_profile" do
    before do
      stub_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update_profile(url: "http://github.com/sferik/")
      expect(a_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/"})).to have_been_made
    end

    it "returns a user" do
      user = @client.update_profile(url: "http://github.com/sferik/")
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end

    context "with multiple options" do
      before do
        stub_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/", name: "Erik Berlin"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes all options in the request" do
        @client.update_profile(url: "http://github.com/sferik/", name: "Erik Berlin")
        expect(a_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/", name: "Erik Berlin"})).to have_been_made
      end
    end

    context "without options" do
      before do
        stub_post("/1.1/account/update_profile.json").with(body: {}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "makes a request with empty body" do
        @client.update_profile
        expect(a_post("/1.1/account/update_profile.json").with(body: {})).to have_been_made
      end
    end
  end

  describe "#update_profile_background_image" do
    before do
      stub_post("/1.1/account/update_profile_background_image.json").to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      expect(a_post("/1.1/account/update_profile_background_image.json")).to have_been_made
    end

    it "returns a user" do
      user = @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end

    context "with options" do
      it "passes options in the request" do
        @client.update_profile_background_image(fixture("we_concept_bg2.png"), tile: true)
        expect(a_post("/1.1/account/update_profile_background_image.json").with { |req|
          req.body.include?("tile")
        }).to have_been_made
      end
    end

    it "uses multipart upload with :image key" do
      image = fixture("we_concept_bg2.png")
      request = instance_double(Twitter::REST::Request, perform: {id: 7_505_382})

      expect(Twitter::REST::Request).to receive(:new).with(
        @client,
        :multipart_post,
        "/1.1/account/update_profile_background_image.json",
        hash_including(tile: true, key: :image, file: image)
      ).and_return(request)

      user = @client.update_profile_background_image(image, tile: true)
      expect(user).to be_a(Twitter::User)
      expect(user.id).to eq(7_505_382)
    end
  end

  describe "#update_profile_image" do
    before do
      stub_post("/1.1/account/update_profile_image.json").to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update_profile_image(fixture("me.jpeg"))
      expect(a_post("/1.1/account/update_profile_image.json")).to have_been_made
    end

    it "returns a user" do
      user = @client.update_profile_image(fixture("me.jpeg"))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end

    context "with options" do
      it "passes options in the request" do
        @client.update_profile_image(fixture("me.jpeg"), skip_status: true)
        expect(a_post("/1.1/account/update_profile_image.json").with { |req|
          req.body.include?("skip_status")
        }).to have_been_made
      end
    end

    it "uses multipart upload with :image key" do
      image = fixture("me.jpeg")
      request = instance_double(Twitter::REST::Request, perform: {id: 7_505_382})

      expect(Twitter::REST::Request).to receive(:new).with(
        @client,
        :multipart_post,
        "/1.1/account/update_profile_image.json",
        hash_including(skip_status: true, key: :image, file: image)
      ).and_return(request)

      user = @client.update_profile_image(image, skip_status: true)
      expect(user).to be_a(Twitter::User)
      expect(user.id).to eq(7_505_382)
    end
  end

  describe "#suggestions" do
    context "with a category slug passed" do
      before do
        stub_get("/1.1/users/suggestions/art-design.json").to_return(body: fixture("category.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.suggestions("art-design")
        expect(a_get("/1.1/users/suggestions/art-design.json")).to have_been_made
      end

      it "returns the users in a given category of the Twitter suggested user list" do
        suggestion = @client.suggestions("art-design")
        expect(suggestion).to be_a Twitter::Suggestion
        expect(suggestion.name).to eq("Art & Design")
        expect(suggestion.users).to be_an Array
        expect(suggestion.users.first).to be_a Twitter::User
      end
    end

    context "without arguments passed" do
      before do
        stub_get("/1.1/users/suggestions.json").to_return(body: fixture("suggestions.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.suggestions
        expect(a_get("/1.1/users/suggestions.json")).to have_been_made
      end

      it "returns the list of suggested user categories" do
        suggestions = @client.suggestions
        expect(suggestions).to be_an Array
        expect(suggestions.first).to be_a Twitter::Suggestion
        expect(suggestions.first.name).to eq("Art & Design")
      end
    end
  end

  describe "#suggest_users" do
    before do
      stub_get("/1.1/users/suggestions/art-design/members.json").to_return(body: fixture("members.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.suggest_users("art-design")
      expect(a_get("/1.1/users/suggestions/art-design/members.json")).to have_been_made
    end

    it "returns users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user" do
      suggest_users = @client.suggest_users("art-design")
      expect(suggest_users).to be_an Array
      expect(suggest_users.first).to be_a Twitter::User
      expect(suggest_users.first.id).to eq(13)
    end
  end

  describe "#blocked" do
    before do
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.blocked
      expect(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1"})).to have_been_made
    end

    it "returns an array of user objects that the authenticating user is blocking" do
      blocked = @client.blocked
      expect(blocked).to be_a Twitter::Cursor
      expect(blocked.first).to be_a Twitter::User
      expect(blocked.first.id).to eq(7_505_382)
    end

    context "with options passed" do
      before do
        stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("users_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.blocked(skip_status: true)
        expect(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1", skip_status: "true"})).to have_been_made
      end
    end

    context "with each" do
      before do
        stub_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.blocked.each {}
        expect(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"})).to have_been_made
      end
    end
  end

  describe "#blocked_ids" do
    before do
      stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.blocked_ids
      expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"})).to have_been_made
    end

    it "returns an array of numeric user IDs the authenticating user is blocking" do
      blocked_ids = @client.blocked_ids
      expect(blocked_ids).to be_a Twitter::Cursor
      expect(blocked_ids.first).to eq(20_009_713)
    end

    context "with a user passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", user_id: "7505382"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes user_id to the request" do
        @client.blocked_ids(7_505_382)
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", user_id: "7505382"})).to have_been_made
      end
    end

    context "with each" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.blocked_ids.each {}
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"})).to have_been_made
      end
    end
  end

  describe "#block?" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.block?("sferik")
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"})).to have_been_made
        expect(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"})).to have_been_made
      end

      it "returns true if block exists" do
        block = @client.block?("pengwynn")
        expect(block).to be true
      end

      it "returns false if block does not exist" do
        block = @client.block?("sferik")
        expect(block).to be false
      end
    end

    context "with a user ID passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resources" do
        @client.block?(7_505_382)
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"})).to have_been_made
      end

      it "returns true when the integer user ID is in the block list" do
        block = @client.block?(20_009_713)
        expect(block).to be true
      end

      it "returns false when the integer user ID is not in the block list" do
        block = @client.block?(999_999_999)
        expect(block).to be false
      end
    end

    context "with a user object passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resources" do
        user = Twitter::User.new(id: "7505382")
        @client.block?(user)
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"})).to have_been_made
      end

      it "returns true when user object id is in the block list" do
        user = Twitter::User.new(id: 20_009_713)
        block = @client.block?(user)
        expect(block).to be true
      end

      it "returns false when user object id is not in the block list" do
        user = Twitter::User.new(id: 999_999_999)
        block = @client.block?(user)
        expect(block).to be false
      end
    end

    context "with a URI passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns true when URI user is in the block list" do
        uri = URI.parse("https://twitter.com/pengwynn")
        block = @client.block?(uri)
        expect(block).to be true
      end
    end

    context "with an Addressable::URI passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns true when Addressable::URI user is in the block list" do
        uri = Addressable::URI.parse("https://twitter.com/pengwynn")
        block = @client.block?(uri)
        expect(block).to be true
      end
    end

    context "with nil passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns false" do
        block = @client.block?(nil)
        expect(block).to be false
      end
    end

    context "with options passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703", skip_status: "true"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to blocked_ids" do
        @client.block?(14_100_886, skip_status: true)
        expect(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", skip_status: "true"})).to have_been_made
      end
    end

    it "coerces blocked IDs to integers and uses empty options by default" do
      expect(@client).to receive(:blocked_ids).with({}).and_return(["20009713"])

      expect(@client.block?(20_009_713)).to be(true)
    end
  end

  describe "#block" do
    before do
      stub_post("/1.1/blocks/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.block("sferik")
      expect(a_post("/1.1/blocks/create.json")).to have_been_made
    end

    it "returns an array of blocked users" do
      users = @client.block("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe "#unblock" do
    before do
      stub_post("/1.1/blocks/destroy.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.unblock("sferik")
      expect(a_post("/1.1/blocks/destroy.json").with(body: {screen_name: "sferik"})).to have_been_made
    end

    it "returns an array of un-blocked users" do
      users = @client.unblock("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe "#users" do
    context "with screen names passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}).to_return(body: fixture("users.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.users("sferik", "pengwynn")
        expect(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"})).to have_been_made
      end

      it "returns up to 100 users worth of extended information" do
        users = @client.users("sferik", "pengwynn")
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7_505_382)
      end

      context "with URI objects passed" do
        it "requests the correct resource" do
          sferik = URI.parse("https://twitter.com/sferik")
          pengwynn = URI.parse("https://twitter.com/pengwynn")
          @client.users(sferik, pengwynn)
          expect(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"})).to have_been_made
        end
      end
    end

    context "with numeric screen names passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "0,311"}).to_return(body: fixture("users.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.users("0", "311")
        expect(a_get("/1.1/users/lookup.json").with(query: {screen_name: "0,311"})).to have_been_made
      end
    end

    context "with user IDs passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}).to_return(body: fixture("users.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.users(7_505_382, 14_100_886)
        expect(a_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"})).to have_been_made
      end
    end

    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"}).to_return(body: fixture("users.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.users("sferik", 14_100_886)
        expect(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"})).to have_been_made
      end
    end

    context "with user objects passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}).to_return(body: fixture("users.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        user1 = Twitter::User.new(id: 7_505_382)
        user2 = Twitter::User.new(id: 14_100_886)
        @client.users(user1, user2)
        expect(a_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"})).to have_been_made
      end
    end
  end

  describe "#user" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user("sferik")
        expect(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"})).to have_been_made
      end

      it "returns extended information of a given user" do
        user = @client.user("sferik")
        expect(user).to be_a Twitter::User
        expect(user.id).to eq(7_505_382)
      end
    end

    context 'with a screen name including "@" passed' do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "@sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user("@sferik")
        expect(a_get("/1.1/users/show.json").with(query: {screen_name: "@sferik"})).to have_been_made
      end
    end

    context "with a numeric screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "0"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user("0")
        expect(a_get("/1.1/users/show.json").with(query: {screen_name: "0"})).to have_been_made
      end
    end

    context "with a user ID passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user(7_505_382)
        expect(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "with a user object passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        user = Twitter::User.new(id: 7_505_382)
        @client.user(user)
        expect(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "when user_id is memoized and no user argument is passed" do
      before do
        @client.instance_variable_set(:@user_id, 7_505_382)
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses users/show with the cached user_id instead of verify_credentials" do
        @client.user

        expect(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"})).to have_been_made
        expect(a_get("/1.1/account/verify_credentials.json")).not_to have_been_made
      end
    end
  end

  context "without a screen name or user ID passed" do
    context "without options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
      end
    end

    context "with options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.user(skip_status: true)
        expect(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"})).to have_been_made
      end
    end
  end

  describe "#user?" do
    before do
      stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("not_found.json"), status: 404, headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.user?("sferik")
      expect(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"})).to have_been_made
    end

    it "returns true if user exists" do
      user = @client.user?("sferik")
      expect(user).to be true
    end

    it "returns false if user does not exist" do
      user = @client.user?("pengwynn")
      expect(user).to be false
    end

    context "with options" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik", skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not modify the original options hash" do
        options = {skip_status: true}
        @client.user?("sferik", options)
        expect(options).to eq({skip_status: true})
        expect(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik", skip_status: "true"})).to have_been_made
      end
    end
  end

  describe "#user_search" do
    before do
      stub_get("/1.1/users/search.json").with(query: {q: "Erik Berlin"}).to_return(body: fixture("user_search.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.user_search("Erik Berlin")
      expect(a_get("/1.1/users/search.json").with(query: {q: "Erik Berlin"})).to have_been_made
    end

    it "returns an array of user search results" do
      user_search = @client.user_search("Erik Berlin")
      expect(user_search).to be_an Array
      expect(user_search.first).to be_a Twitter::User
      expect(user_search.first.id).to eq(7_505_382)
    end

    context "with options" do
      before do
        stub_get("/1.1/users/search.json").with(query: {q: "Erik Berlin", page: "2"}).to_return(body: fixture("user_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not modify the original options hash" do
        options = {page: 2}
        @client.user_search("Erik Berlin", options)
        expect(options).to eq({page: 2})
        expect(options.key?(:q)).to be false
        expect(a_get("/1.1/users/search.json").with(query: {q: "Erik Berlin", page: "2"})).to have_been_made
      end
    end
  end

  describe "#contributees" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("contributees.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributees("sferik")
        expect(a_get("/1.1/users/contributees.json").with(query: {screen_name: "sferik"})).to have_been_made
      end

      it "returns contributees" do
        contributees = @client.contributees("sferik")
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq("Twitter API")
      end
    end

    context "with a user ID passed" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributees(7_505_382)
        expect(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributees
        expect(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"})).to have_been_made
        expect(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"})).to have_been_made
      end

      it "returns contributees" do
        contributees = @client.contributees
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq("Twitter API")
      end
    end

    context "with user_id in options" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not call verify_credentials when user_id is already in options" do
        @client.contributees(user_id: 7_505_382)
        expect(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end
  end

  describe "#contributors" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/users/contributors.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("members.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributors("sferik")
        expect(a_get("/1.1/users/contributors.json").with(query: {screen_name: "sferik"})).to have_been_made
      end

      it "returns contributors" do
        contributors = @client.contributors("sferik")
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.id).to eq(13)
      end
    end

    context "with a user ID passed" do
      before do
        stub_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}).to_return(body: fixture("members.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributors(7_505_382)
        expect(a_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}).to_return(body: fixture("members.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.contributors
        expect(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"})).to have_been_made
        expect(a_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"})).to have_been_made
      end

      it "returns contributors" do
        contributors = @client.contributors
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.id).to eq(13)
      end
    end
  end

  describe "#remove_profile_banner" do
    before do
      stub_post("/1.1/account/remove_profile_banner.json").to_return(body: "{}", headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.remove_profile_banner
      expect(a_post("/1.1/account/remove_profile_banner.json")).to have_been_made
    end

    it "returns a user" do
      response = @client.remove_profile_banner
      expect(response).to be true
    end

    context "with options" do
      before do
        stub_post("/1.1/account/remove_profile_banner.json").with(body: {include_entities: "true"}).to_return(body: "{}", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options in the request" do
        @client.remove_profile_banner(include_entities: true)
        expect(a_post("/1.1/account/remove_profile_banner.json").with(body: {include_entities: "true"})).to have_been_made
      end
    end
  end

  describe "#update_profile_banner" do
    before do
      stub_post("/1.1/account/update_profile_banner.json").to_return(body: "{}", headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update_profile_banner(fixture("me.jpeg"))
      expect(a_post("/1.1/account/update_profile_banner.json")).to have_been_made
    end

    it "returns a user" do
      response = @client.update_profile_banner(fixture("me.jpeg"))
      expect(response).to be true
    end

    context "with options" do
      it "passes options in the request" do
        @client.update_profile_banner(fixture("me.jpeg"), width: 800, height: 400)
        expect(a_post("/1.1/account/update_profile_banner.json").with { |req|
          req.body.include?("width") && req.body.include?("height")
        }).to have_been_made
      end
    end

    it "merges the banner into options using the :banner key" do
      banner = fixture("me.jpeg")
      expect(@client).to receive(:perform_post)
        .with("/1.1/account/update_profile_banner.json", hash_including(width: 800, banner: banner))
        .and_return({})

      expect(@client.update_profile_banner(banner, width: 800)).to be(true)
    end
  end

  describe "#profile_banner" do
    context "with a screen_name passed" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("profile_banner.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.profile_banner("sferik")
        expect(a_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"})).to have_been_made
      end

      it "returns a profile banner" do
        banner = @client.profile_banner("sferik")
        expect(banner).to be_a Twitter::ProfileBanner
        expect(banner.sizes).to be_a Hash
        expect(banner.sizes[:mobile].height).to eq(160)
      end
    end

    context "with a user ID passed" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.profile_banner(7_505_382)
        expect(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.profile_banner
        expect(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"})).to have_been_made
        expect(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"})).to have_been_made
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        banner = @client.profile_banner
        expect(banner).to be_a Twitter::ProfileBanner
        expect(banner.sizes).to be_a Hash
        expect(banner.sizes[:mobile].height).to eq(160)
      end
    end

    context "with user_id in options" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not call verify_credentials when user_id is already in options" do
        @client.profile_banner(user_id: 7_505_382)
        expect(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"})).to have_been_made
      end
    end

    context "with screen_name in options" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("profile_banner.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not call verify_credentials when screen_name is already in options" do
        @client.profile_banner(screen_name: "sferik")
        expect(a_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"})).to have_been_made
      end
    end
  end

  describe "#mute" do
    before do
      stub_post("/1.1/mutes/users/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.mute("sferik")
      expect(a_post("/1.1/mutes/users/create.json")).to have_been_made
    end

    it "returns an array of muteed users" do
      users = @client.mute("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe "#unmute" do
    before do
      stub_post("/1.1/mutes/users/destroy.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.unmute("sferik")
      expect(a_post("/1.1/mutes/users/destroy.json").with(body: {screen_name: "sferik"})).to have_been_made
    end

    it "returns an array of un-muteed users" do
      users = @client.unmute("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe "#muted" do
    before do
      stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.muted
      expect(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"})).to have_been_made
    end

    it "returns an array of user objects that the authenticating user is muting" do
      muted = @client.muted
      expect(muted).to be_a Twitter::Cursor
      expect(muted.first).to be_a Twitter::User
      expect(muted.first.id).to eq(7_505_382)
    end

    context "with options passed" do
      before do
        stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("users_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.muted(skip_status: true)
        expect(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1", skip_status: "true"})).to have_been_made
      end
    end

    context "with each" do
      before do
        stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.muted.each {}
        expect(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "1322801608223717003"})).to have_been_made
      end
    end
  end

  describe "#muted_ids" do
    before do
      stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.muted_ids
      expect(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"})).to have_been_made
    end

    it "returns an array of numeric user IDs the authenticating user is muting" do
      muted_ids = @client.muted_ids
      expect(muted_ids).to be_a Twitter::Cursor
      expect(muted_ids.first).to eq(20_009_713)
    end

    context "with a user passed" do
      before do
        stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1", user_id: "7505382"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes user_id to the request" do
        @client.muted_ids(7_505_382)
        expect(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1", user_id: "7505382"})).to have_been_made
      end
    end

    context "with each" do
      before do
        stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.muted_ids.each {}
        expect(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "1305102810874389703"})).to have_been_made
      end
    end
  end

  describe "Twitter::REST::Utils helper behavior" do
    let(:utils_client_class) do
      Class.new do
        include Twitter::REST::Utils

        attr_accessor :credentials_id

        def verify_credentials(skip_status:)
          raise ArgumentError, "skip_status must be true" unless skip_status

          Struct.new(:id).new(credentials_id)
        end
      end
    end

    let(:utils_client) do
      utils_client_class.new.tap do |instance|
        instance.credentials_id = 4_242
      end
    end

    describe "#extract_id" do
      it "extracts integer IDs from each supported input type" do
        identity = Twitter::Identity.new(id: 99)
        uri = URI.parse("https://twitter.com/sferik/123")
        addressable_uri = Addressable::URI.parse("https://twitter.com/sferik/456")

        expect(utils_client.send(:extract_id, 1)).to eq(1)
        expect(utils_client.send(:extract_id, "https://twitter.com/sferik/2")).to eq(2)
        expect(utils_client.send(:extract_id, uri)).to eq(123)
        expect(utils_client.send(:extract_id, addressable_uri)).to eq(456)
        expect(utils_client.send(:extract_id, identity)).to eq(99)
      end
    end

    describe "#perform_get" do
      it "delegates to perform_request with default empty options" do
        expect(utils_client).to receive(:perform_request).with(:get, "/path", {}).and_return(:ok)

        expect(utils_client.send(:perform_get, "/path")).to eq(:ok)
      end
    end

    describe "#perform_post" do
      it "delegates to perform_request with default empty options" do
        expect(utils_client).to receive(:perform_request).with(:post, "/path", {}).and_return(:ok)

        expect(utils_client.send(:perform_post, "/path")).to eq(:ok)
      end
    end

    describe "#perform_get_with_cursor" do
      it "uses merge_default_cursor! when no_default_cursor is false" do
        options = {no_default_cursor: false}
        request = instance_double(Twitter::REST::Request)

        expect(utils_client).to receive(:merge_default_cursor!).with(options)
        expect(Twitter::REST::Request).to receive(:new).with(utils_client, :get, "/path", options).and_return(request)
        expect(Twitter::Cursor).to receive(:new).with(:friends, nil, request, nil).and_return(:cursor)

        expect(utils_client.send(:perform_get_with_cursor, "/path", options, :friends)).to eq(:cursor)
      end

      it "removes no_default_cursor and passes limit explicitly to Cursor" do
        options = {no_default_cursor: true, limit: 10}
        request = instance_double(Twitter::REST::Request)

        expect(utils_client).not_to receive(:merge_default_cursor!)
        expect(Twitter::REST::Request).to receive(:new).with(utils_client, :get, "/path", {}).and_return(request)
        expect(Twitter::Cursor).to receive(:new).with(:friends, nil, request, 10).and_return(:cursor)

        expect(utils_client.send(:perform_get_with_cursor, "/path", options, :friends)).to eq(:cursor)
        expect(options).to eq({})
      end
    end

    describe "#users_from_response" do
      it "falls back to the current user_id when no user_id/screen_name option is present" do
        allow(utils_client).to receive(:user_id).and_return(55)
        expect(utils_client).to receive(:perform_request_with_objects).with(:get, "/users", {user_id: 55}, Twitter::User).and_return([])

        expect(utils_client.send(:users_from_response, :get, "/users", [])).to eq([])
      end

      it "does not inject user_id when screen_name is already provided" do
        options = {screen_name: "sferik"}
        expect(utils_client).not_to receive(:user_id)
        expect(utils_client).to receive(:perform_request_with_objects).with(:get, "/users", options, Twitter::User).and_return([])

        utils_client.send(:users_from_response, :get, "/users", [options])
      end

      it "does not inject user_id when user_id is already provided" do
        options = {user_id: 11}
        expect(utils_client).not_to receive(:user_id)
        expect(utils_client).to receive(:perform_request_with_objects).with(:get, "/users", options, Twitter::User).and_return([])

        utils_client.send(:users_from_response, :get, "/users", [options])
      end
    end

    describe "#cursor_from_response_with_user" do
      it "injects current user_id when neither user_id nor screen_name is provided" do
        allow(utils_client).to receive(:user_id).and_return(77)
        expect(utils_client).to receive(:perform_get_with_cursor).with("/followers", {user_id: 77}, :users, Twitter::User).and_return(:cursor)

        expect(utils_client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [])).to eq(:cursor)
      end

      it "keeps explicit screen_name untouched" do
        options = {screen_name: "sferik"}
        expect(utils_client).not_to receive(:user_id)
        expect(utils_client).to receive(:perform_get_with_cursor).with("/followers", options, :users, Twitter::User).and_return(:cursor)

        expect(utils_client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [options])).to eq(:cursor)
      end
    end

    describe "#user_id?" do
      it "is false until user_id is memoized and true afterwards" do
        expect(utils_client.send(:user_id?)).to be(false)

        utils_client.send(:user_id)

        expect(utils_client.send(:user_id?)).to be(true)
      end
    end

    describe "#merge_default_cursor!" do
      it "assigns the default cursor when cursor is nil" do
        options = {cursor: nil}
        utils_client.send(:merge_default_cursor!, options)

        expect(options[:cursor]).to eq(Twitter::REST::Utils::DEFAULT_CURSOR)
      end

      it "assigns the default cursor when cursor is false" do
        options = {cursor: false}
        utils_client.send(:merge_default_cursor!, options)

        expect(options[:cursor]).to eq(Twitter::REST::Utils::DEFAULT_CURSOR)
      end
    end

    describe "#merge_user" do
      it "returns a new hash and keeps the original unchanged" do
        original = {trim_user: true}

        result = utils_client.send(:merge_user, original, 123)

        expect(result).to eq(trim_user: true, user_id: 123)
        expect(original).to eq(trim_user: true)
      end

      it "respects an explicit prefix" do
        result = utils_client.send(:merge_user, {}, 123, "target")

        expect(result).to eq(target_user_id: 123)
      end
    end

    describe "#merge_user!" do
      it "extracts screen_name from URI-like inputs" do
        hash = {}
        utils_client.send(:merge_user!, hash, URI.parse("https://twitter.com/sferik"))

        expect(hash).to eq(screen_name: "sferik")
      end
    end

    describe "#set_compound_key" do
      it "uses a nil prefix by default" do
        hash = {}

        expect(utils_client.send(:set_compound_key, "screen_name", "sferik", hash)).to eq(screen_name: "sferik")
      end
    end

    describe "#merge_users" do
      it "returns a copy and does not mutate the input hash" do
        original = {trim_user: true}

        result = utils_client.send(:merge_users, original, [1, "sferik"])

        expect(original).to eq(trim_user: true)
        expect(result).to eq(trim_user: true, user_id: "1", screen_name: "sferik")
      end
    end

    describe "#merge_users!" do
      it "deduplicates users before collecting IDs and screen_names" do
        hash = {}
        users = [1, 1, "sferik", "sferik"]

        utils_client.send(:merge_users!, hash, users)

        expect(hash[:user_id]).to eq("1")
        expect(hash[:screen_name]).to eq("sferik")
      end
    end

    describe "#collect_users" do
      it "collects IDs and screen names from all supported types" do
        users = [
          1,
          Twitter::User.new(id: 2),
          "sferik",
          URI.parse("https://twitter.com/erik"),
          Addressable::URI.parse("https://twitter.com/alice"),
        ]

        user_ids, screen_names = utils_client.send(:collect_users, users)
        expect(user_ids).to eq([1, 2])
        expect(screen_names).to eq(%w[sferik erik alice])
      end
    end
  end

  describe "Twitter::REST::UploadUtils helper behavior" do
    let(:upload_client_class) do
      Class.new do
        include Twitter::REST::UploadUtils

        attr_accessor :timeouts
      end
    end

    let(:upload_client) { upload_client_class.new }

    describe "#upload" do
      it "uses multipart upload with :media key for non-chunked uploads" do
        media = fixture("pbjt.gif")
        response = {media_id: 1}
        request = instance_double(Twitter::REST::Request, perform: response)

        allow(File).to receive(:size).with(media).and_return(1_024)
        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :multipart_post,
          "https://upload.twitter.com/1.1/media/upload.json",
          hash_including(key: :media, file: media)
        ).and_return(request)

        expect(upload_client.send(:upload, media)).to eq(response)
      end

      it "chunks gif uploads only when size is above 5,000,000 bytes" do
        media = fixture("pbjt.gif")
        allow(File).to receive(:size).with(media).and_return(5_000_001)

        expect(upload_client).to receive(:chunk_upload).with(media, "image/gif", "tweet_gif").and_return(:chunked)
        expect(upload_client.send(:upload, media)).to eq(:chunked)
      end

      it "does not chunk a gif upload at exactly 5,000,000 bytes" do
        media = fixture("pbjt.gif")
        request = instance_double(Twitter::REST::Request, perform: {media_id: 1})
        allow(File).to receive(:size).with(media).and_return(5_000_000)

        expect(upload_client).not_to receive(:chunk_upload)
        expect(Twitter::REST::Request).to receive(:new).and_return(request)
        upload_client.send(:upload, media)
      end

      it "does not chunk large non-gif files" do
        media = fixture("we_concept_bg2.png")
        request = instance_double(Twitter::REST::Request, perform: {media_id: 1})
        allow(File).to receive(:size).with(media).and_return(8_000_000)

        expect(upload_client).not_to receive(:chunk_upload)
        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :multipart_post,
          "https://upload.twitter.com/1.1/media/upload.json",
          hash_including(key: :media, file: media)
        ).and_return(request)
        upload_client.send(:upload, media)
      end
    end

    describe "#chunk_upload" do
      it "initializes, appends, closes media, and finalizes with expected arguments" do
        media = instance_double(File, size: 123_456)
        init_response = {media_id: 42}
        init_request = instance_double(Twitter::REST::Request, perform: init_response)

        expect(Timeout).to receive(:timeout).with(nil, Twitter::Error::TimeoutError).and_yield
        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :post,
          "https://upload.twitter.com/1.1/media/upload.json",
          hash_including(command: "INIT", media_type: "video/mp4", media_category: "tweet_video", total_bytes: 123_456)
        ).and_return(init_request)
        expect(upload_client).to receive(:append_media).with(media, 42)
        expect(media).to receive(:close)
        expect(upload_client).to receive(:finalize_media).with(42).and_return(:finalized)

        expect(upload_client.send(:chunk_upload, media, "video/mp4", "tweet_video")).to eq(:finalized)
      end
    end

    describe "#append_media" do
      it "reads 5,000,000-byte chunks and uploads StringIO chunks with :media key" do
        media = instance_double(IO)
        request = instance_double(Twitter::REST::Request, perform: nil)

        allow(media).to receive(:eof?).and_return(false, true)
        expect(media).to receive(:read).with(5_000_000).and_return("abc")
        expect(Twitter::REST::Request).to receive(:new) do |client, method, path, options|
          expect(client).to eq(upload_client)
          expect(method).to eq(:multipart_post)
          expect(path).to eq("https://upload.twitter.com/1.1/media/upload.json")
          expect(options[:command]).to eq("APPEND")
          expect(options[:media_id]).to eq(9)
          expect(options[:segment_index]).to eq(0)
          expect(options[:key]).to eq(:media)
          expect(options[:file]).to be_a(StringIO)
          expect(options[:file].read).to eq("abc")
          request
        end
        expect(request).to receive(:perform)

        upload_client.send(:append_media, media, 9)
      end
    end

    describe "#finalize_media" do
      it "returns immediately when processing state is failed" do
        failed = {processing_info: {state: "failed"}}
        request = instance_double(Twitter::REST::Request, perform: failed)

        expect(Twitter::REST::Request).to receive(:new).once.with(
          upload_client,
          :post,
          "https://upload.twitter.com/1.1/media/upload.json",
          command: "FINALIZE",
          media_id: 77
        ).and_return(request)
        expect(upload_client).not_to receive(:sleep)

        expect(upload_client.send(:finalize_media, 77)).to eq(failed)
      end

      it "polls status until upload processing succeeds" do
        pending = {processing_info: {state: "pending", check_after_secs: 2}}
        succeeded = {processing_info: {state: "succeeded"}}
        post_request = instance_double(Twitter::REST::Request, perform: pending)
        get_request = instance_double(Twitter::REST::Request, perform: succeeded)

        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :post,
          "https://upload.twitter.com/1.1/media/upload.json",
          command: "FINALIZE",
          media_id: 88
        ).ordered.and_return(post_request)
        expect(upload_client).to receive(:sleep).with(2).ordered
        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :get,
          "https://upload.twitter.com/1.1/media/upload.json",
          command: "STATUS",
          media_id: 88
        ).ordered.and_return(get_request)

        expect(upload_client.send(:finalize_media, 88)).to eq(succeeded)
      end

      it "handles pending processing_info without an explicit state key" do
        pending_without_state = {processing_info: {check_after_secs: 1}}
        succeeded = {processing_info: {state: "succeeded"}}
        post_request = instance_double(Twitter::REST::Request, perform: pending_without_state)
        get_request = instance_double(Twitter::REST::Request, perform: succeeded)

        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :post,
          "https://upload.twitter.com/1.1/media/upload.json",
          command: "FINALIZE",
          media_id: 89
        ).ordered.and_return(post_request)
        expect(upload_client).to receive(:sleep).with(1).ordered
        expect(Twitter::REST::Request).to receive(:new).with(
          upload_client,
          :get,
          "https://upload.twitter.com/1.1/media/upload.json",
          command: "STATUS",
          media_id: 89
        ).ordered.and_return(get_request)

        expect(upload_client.send(:finalize_media, 89)).to eq(succeeded)
      end
    end
  end
end
