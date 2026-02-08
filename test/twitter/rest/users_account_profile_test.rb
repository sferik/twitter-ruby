require "test_helper"

describe Twitter::REST::Users do
  before do
    @client = build_rest_client
  end

  describe "#settings" do
    before do
      stub_json_get("/1.1/account/settings.json", body: fixture("settings.json"))
      stub_post("/1.1/account/settings.json").with(body: {trend_location_woeid: "23424803"}).to_return(body: fixture("settings.json"), headers: json_headers)
    end

    describe "on GET" do
      it "requests the correct resource" do
        @client.settings

        assert_requested(a_get("/1.1/account/settings.json"))
      end

      it "returns settings" do
        settings = @client.settings

        assert_kind_of(Twitter::Settings, settings)
        assert_equal("en", settings.language)
      end

      it "returns the first trend location from the response array" do
        settings = @client.settings

        assert_kind_of(Twitter::Place, settings.trend_location)
        assert_equal("San Francisco", settings.trend_location.name)
        assert_equal(2_487_956, settings.trend_location.woeid)
      end
    end

    describe "when response has no trend_location" do
      before do
        stub_json_get("/1.1/account/settings.json", body: '{"language":"en"}')
      end

      it "returns nil for trend_location when not present in response" do
        settings = @client.settings

        assert_nil(settings.trend_location)
      end
    end

    describe "on POST" do
      it "requests the correct resource" do
        @client.settings(trend_location_woeid: "23424803")

        assert_requested(a_post("/1.1/account/settings.json").with(body: {trend_location_woeid: "23424803"}))
      end

      it "returns settings" do
        settings = @client.settings(trend_location_woeid: "23424803")

        assert_kind_of(Twitter::Settings, settings)
        assert_equal("en", settings.language)
      end
    end
  end

  describe "#verify_credentials" do
    before do
      stub_json_get("/1.1/account/verify_credentials.json", body: fixture("sferik.json"))
    end

    it "requests the correct resource" do
      @client.verify_credentials

      assert_requested(a_get("/1.1/account/verify_credentials.json"))
    end

    it "returns the requesting user" do
      user = @client.verify_credentials

      assert_kind_of(Twitter::User, user)
      assert_equal(7_505_382, user.id)
    end
  end

  describe "#update_delivery_device" do
    before do
      stub_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.update_delivery_device("sms")

      assert_requested(a_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms"}))
    end

    it "returns a user" do
      user = @client.update_delivery_device("sms")

      assert_kind_of(Twitter::User, user)
      assert_equal(7_505_382, user.id)
    end

    describe "with options" do
      before do
        stub_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms", include_entities: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "passes options in the request" do
        @client.update_delivery_device("sms", include_entities: true)

        assert_requested(a_post("/1.1/account/update_delivery_device.json").with(body: {device: "sms", include_entities: "true"}))
      end
    end
  end

  describe "#update_profile" do
    before do
      stub_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.update_profile(url: "http://github.com/sferik/")

      assert_requested(a_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/"}))
    end

    it "returns a user" do
      user = @client.update_profile(url: "http://github.com/sferik/")

      assert_kind_of(Twitter::User, user)
      assert_equal(7_505_382, user.id)
    end

    describe "with multiple options" do
      before do
        stub_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/", name: "Erik Berlin"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "passes all options in the request" do
        @client.update_profile(url: "http://github.com/sferik/", name: "Erik Berlin")

        assert_requested(a_post("/1.1/account/update_profile.json").with(body: {url: "http://github.com/sferik/", name: "Erik Berlin"}))
      end
    end

    describe "without options" do
      before do
        stub_post("/1.1/account/update_profile.json").with(body: {}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "makes a request with empty body" do
        @client.update_profile

        assert_requested(a_post("/1.1/account/update_profile.json").with(body: {}))
      end
    end
  end

  profile_image_upload_examples(
    method_name: :update_profile_background_image,
    path: "/1.1/account/update_profile_background_image.json",
    fixture_name: "we_concept_bg2.png",
    option_key: :tile
  )

  profile_image_upload_examples(
    method_name: :update_profile_image,
    path: "/1.1/account/update_profile_image.json",
    fixture_name: "me.jpeg",
    option_key: :skip_status
  )
end
