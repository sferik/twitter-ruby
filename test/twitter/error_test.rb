require "test_helper"

describe Twitter::Error do
  before do
    @client = build_rest_client
  end

  describe "#code" do
    it "returns the error code" do
      error = Twitter::Error.new("execution expired", {}, 123)

      assert_equal(123, error.code)
    end
  end

  describe "#message" do
    it "returns the error message" do
      error = Twitter::Error.new("execution expired", {}, nil)

      assert_equal("execution expired", error.message)
    end

    it "defaults to empty string when no message provided" do
      error = Twitter::Error.new

      assert_equal("", error.message)
    end
  end

  describe "#rate_limit" do
    it "returns a rate limit object" do
      error = Twitter::Error.new("execution expired", {}, nil)

      assert_kind_of(Twitter::RateLimit, error.rate_limit)
    end

    it "passes rate limit headers to RateLimit" do
      headers = {"x-rate-limit-limit" => "100"}
      error = Twitter::Error.new("error", headers, nil)

      assert_equal(100, error.rate_limit.limit)
    end

    it "uses an empty hash as the default rate_limit argument" do
      rate_limit = Object.new
      called = false

      Twitter::RateLimit.stub(:new, lambda { |headers|
        called = true

        assert_empty(headers)
        rate_limit
      }) do
        assert_equal(rate_limit, Twitter::Error.new.rate_limit)
      end

      assert(called)
    end
  end

  describe ".from_response" do
    it "creates error with message from error key" do
      body = {error: "Something went wrong"}
      error = Twitter::Error.from_response(body, {})

      assert_equal("Something went wrong", error.message)
    end

    it "creates error with message from errors array of strings" do
      body = {errors: ["First error\n", "Second error"]}
      error = Twitter::Error.from_response(body, {})

      assert_equal("First error", error.message)
    end

    it "creates error with message and code from errors array of hashes" do
      body = {errors: [{message: "Rate limit exceeded\n", code: 88}]}
      error = Twitter::Error.from_response(body, {})

      assert_equal("Rate limit exceeded", error.message)
      assert_equal(88, error.code)
    end

    it "handles nil body" do
      error = Twitter::Error.from_response(nil, {})

      assert_equal("", error.message)
    end

    it "handles empty body" do
      error = Twitter::Error.from_response("", {})

      assert_equal("", error.message)
    end

    it "returns nil code for error key body" do
      body = {error: "Something went wrong"}
      error = Twitter::Error.from_response(body, {})

      assert_nil(error.code)
    end

    it "passes headers to the error for rate limiting" do
      body = {error: "Rate limited"}
      headers = {"x-rate-limit-limit" => "100", "x-rate-limit-remaining" => "0"}
      error = Twitter::Error.from_response(body, headers)

      assert_equal(100, error.rate_limit.limit)
      assert_equal(0, error.rate_limit.remaining)
    end

    it "returns nil code for nil body" do
      error = Twitter::Error.from_response(nil, {})

      assert_nil(error.code)
    end

    it "returns nil code for empty body" do
      error = Twitter::Error.from_response("", {})

      assert_nil(error.code)
    end
  end

  describe ".from_processing_response" do
    it "creates MediaError with message and code" do
      error_hash = {name: "InvalidMedia", message: "Bad media", code: 123}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_kind_of(Twitter::Error::InvalidMedia, error)
      assert_equal("Bad media", error.message)
      assert_equal(123, error.code)
    end

    it "creates MediaInternalError for InternalError name" do
      error_hash = {name: "InternalError", message: "Internal error", code: 1}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_kind_of(Twitter::Error::MediaInternalError, error)
    end

    it "creates UnsupportedMedia for UnsupportedMedia name" do
      error_hash = {name: "UnsupportedMedia", message: "Unsupported", code: 2}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_kind_of(Twitter::Error::UnsupportedMedia, error)
    end

    it "falls back to base MediaError for unknown names" do
      error_hash = {name: "UnknownError", message: "Unknown", code: 3}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_kind_of(Twitter::Error, error)
    end

    it "passes headers to the error for rate limiting" do
      error_hash = {name: "InvalidMedia", message: "Bad media", code: 123}
      headers = {"x-rate-limit-limit" => "50", "x-rate-limit-remaining" => "49"}
      error = Twitter::Error.from_processing_response(error_hash, headers)

      assert_equal(50, error.rate_limit.limit)
      assert_equal(49, error.rate_limit.remaining)
    end

    it "extracts message from error hash" do
      error_hash = {name: "InvalidMedia", message: "Specific message", code: 1}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_equal("Specific message", error.message)
    end

    it "extracts code from error hash" do
      error_hash = {name: "InvalidMedia", message: "msg", code: 999}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_equal(999, error.code)
    end

    it "extracts name from error hash to determine error class" do
      error_hash = {name: "UnsupportedMedia", message: "msg", code: 1}
      error = Twitter::Error.from_processing_response(error_hash, {})

      assert_kind_of(Twitter::Error::UnsupportedMedia, error)
    end

    it "falls back to base error class when :name is missing" do
      error = Twitter::Error.from_processing_response({message: "msg", code: 1}, {})

      assert_kind_of(Twitter::Error, error)
      refute_kind_of(Twitter::Error::MediaError, error)
    end

    it "allows missing :message without raising" do
      error = Twitter::Error.from_processing_response({name: "InvalidMedia", code: 1}, {})

      assert_kind_of(Twitter::Error::InvalidMedia, error)
      assert_equal(1, error.code)
    end

    it "allows missing :code and sets nil code" do
      error = Twitter::Error.from_processing_response({name: "InvalidMedia", message: "Bad media"}, {})

      assert_kind_of(Twitter::Error::InvalidMedia, error)
      assert_nil(error.code)
    end
  end

  describe "private parser helpers" do
    describe ".parse_error" do
      it "returns a two-element tuple for empty input" do
        assert_equal(["", nil], Twitter::Error.send(:parse_error, nil))
      end

      it "prefers :errors when :error key is present with nil value" do
        body = {error: nil, errors: ["From errors\n"]}

        assert_equal(["From errors", nil], Twitter::Error.send(:parse_error, body))
      end

      it "returns nil when only a nil :errors key is present" do
        assert_nil(Twitter::Error.send(:parse_error, {errors: nil}))
      end

      it "returns a two-element tuple for :error values" do
        result = Twitter::Error.send(:parse_error, {error: "boom"})

        assert_equal(["boom", nil], result)
        assert_equal(2, result.length)
      end
    end

    describe ".extract_message_from_errors" do
      it "handles Hash subclasses as error objects" do
        hash_subclass = Class.new(Hash)
        first = hash_subclass[message: "Subclassed\n", code: 7]

        assert_equal(["Subclassed", 7], Twitter::Error.send(:extract_message_from_errors, {errors: [first]}))
      end

      it "raises NoMethodError when :errors key is missing" do
        assert_raises(NoMethodError) { Twitter::Error.send(:extract_message_from_errors, {}) }
      end

      it "raises NoMethodError when hash error has no :message key" do
        body = {errors: [{code: 12}]}

        assert_raises(NoMethodError) { Twitter::Error.send(:extract_message_from_errors, body) }
      end

      it "returns nil code when hash error has no :code key" do
        result = Twitter::Error.send(:extract_message_from_errors, {errors: [{message: "No code\n"}]})

        assert_equal(["No code", nil], result)
        assert_equal(2, result.length)
      end

      it "returns a two-element tuple for string errors" do
        result = Twitter::Error.send(:extract_message_from_errors, {errors: ["Simple error\n"]})

        assert_equal(["Simple error", nil], result)
        assert_equal(2, result.length)
      end
    end
  end

  describe "FORBIDDEN_MESSAGES" do
    it "returns DuplicateStatus for duplicate status message" do
      assert_equal(Twitter::Error::DuplicateStatus, Twitter::Error::FORBIDDEN_MESSAGES["Status is a duplicate."])
    end

    it "returns AlreadyFavorited for already favorited message" do
      assert_equal(Twitter::Error::AlreadyFavorited, Twitter::Error::FORBIDDEN_MESSAGES["You have already favorited this status."])
    end

    it "returns AlreadyRetweeted for already retweeted message" do
      assert_equal(Twitter::Error::AlreadyRetweeted, Twitter::Error::FORBIDDEN_MESSAGES["You have already retweeted this Tweet."])
    end

    it "returns AlreadyRetweeted for share validations failed message" do
      assert_equal(Twitter::Error::AlreadyRetweeted, Twitter::Error::FORBIDDEN_MESSAGES["sharing is not permissible for this status (Share validations failed)"])
    end

    it "returns nil for unknown message" do
      assert_nil(Twitter::Error::FORBIDDEN_MESSAGES["Some other error"])
    end
  end

  %w[error errors].each do |key|
    describe "when JSON body contains #{key}" do
      before do
        body = "{\"#{key}\":\"Internal Server Error\"}"
        stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status: 500, body:, headers: json_headers)
      end

      it "raises an exception with the proper message" do
        assert_raises(Twitter::Error::InternalServerError) { @client.user_timeline("sferik") }
      end
    end
  end

  describe "when JSON body contains neither error nor errors" do
    before do
      body = '{"foo":"bar"}'
      stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status: 500, body:, headers: json_headers)
    end

    it "raises an exception with empty message" do
      assert_raises(Twitter::Error::InternalServerError) { @client.user_timeline("sferik") }
    end
  end

  Twitter::Error::ERRORS.each do |status, exception|
    describe "when HTTP status is #{status}" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status:, body: "{}", headers: json_headers)
      end

      it "raises #{exception}" do
        assert_raises(exception) { @client.user_timeline("sferik") }
      end
    end
  end
end
