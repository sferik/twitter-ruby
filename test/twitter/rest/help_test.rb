require "test_helper"

describe Twitter::REST::Help do
  before do
    @client = build_rest_client
  end

  describe "#languages" do
    before do
      stub_get("/1.1/help/languages.json").to_return(body: fixture("languages.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.languages

      assert_requested(a_get("/1.1/help/languages.json"))
    end

    it "returns the list of languages supported by Twitter" do
      languages = @client.languages

      assert_kind_of(Array, languages)
      assert_kind_of(Twitter::Language, languages.first)
      assert_equal("Portuguese", languages.first.name)
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/languages.json").with(query: {foo: "bar"}).to_return(body: fixture("languages.json"), headers: json_headers)
      @client.languages(foo: "bar")

      assert_requested(a_get("/1.1/help/languages.json").with(query: {foo: "bar"}))
    end
  end

  describe "#privacy" do
    before do
      stub_get("/1.1/help/privacy.json").to_return(body: fixture("privacy.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.privacy

      assert_requested(a_get("/1.1/help/privacy.json"))
    end

    it "returns the Twitter Privacy Policy" do
      privacy = @client.privacy

      assert_equal("Twitter", privacy.split.first)
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/privacy.json").with(query: {foo: "bar"}).to_return(body: fixture("privacy.json"), headers: json_headers)
      @client.privacy(foo: "bar")

      assert_requested(a_get("/1.1/help/privacy.json").with(query: {foo: "bar"}))
    end

    it "uses hash defaults when the privacy key is missing" do
      fallback = Hash.new("fallback privacy")
      called = false

      @client.stub(:perform_get, lambda { |path, options|
        called = true

        assert_equal("/1.1/help/privacy.json", path)
        assert_empty(options)
        fallback
      }) do
        assert_equal("fallback privacy", @client.privacy)
      end
      assert(called)
    end
  end

  describe "#tos" do
    before do
      stub_get("/1.1/help/tos.json").to_return(body: fixture("tos.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.tos

      assert_requested(a_get("/1.1/help/tos.json"))
    end

    it "returns the Twitter Terms of Service" do
      tos = @client.tos

      assert_equal("Terms", tos.split.first)
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/tos.json").with(query: {foo: "bar"}).to_return(body: fixture("tos.json"), headers: json_headers)
      @client.tos(foo: "bar")

      assert_requested(a_get("/1.1/help/tos.json").with(query: {foo: "bar"}))
    end

    it "uses hash defaults when the tos key is missing" do
      fallback = Hash.new("fallback tos")
      called = false

      @client.stub(:perform_get, lambda { |path, options|
        called = true

        assert_equal("/1.1/help/tos.json", path)
        assert_empty(options)
        fallback
      }) do
        assert_equal("fallback tos", @client.tos)
      end
      assert(called)
    end
  end
end
