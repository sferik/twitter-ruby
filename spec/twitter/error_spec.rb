require "helper"

describe Twitter::Error do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#code" do
    it "returns the error code" do
      error = described_class.new("execution expired", {}, 123)
      expect(error.code).to eq(123)
    end
  end

  describe "#message" do
    it "returns the error message" do
      error = described_class.new("execution expired", {}, nil)
      expect(error.message).to eq("execution expired")
    end

    it "defaults to empty string when no message provided" do
      error = described_class.new
      expect(error.message).to eq("")
    end
  end

  describe "#rate_limit" do
    it "returns a rate limit object" do
      error = described_class.new("execution expired", {}, nil)
      expect(error.rate_limit).to be_a Twitter::RateLimit
    end

    it "passes rate limit headers to RateLimit" do
      headers = {"x-rate-limit-limit" => "100"}
      error = described_class.new("error", headers, nil)
      expect(error.rate_limit.limit).to eq(100)
    end

    it "uses an empty hash as the default rate_limit argument" do
      rate_limit = instance_double(Twitter::RateLimit)

      expect(Twitter::RateLimit).to receive(:new).with({}).and_return(rate_limit)
      expect(described_class.new.rate_limit).to eq(rate_limit)
    end
  end

  describe ".from_response" do
    it "creates error with message from error key" do
      body = {error: "Something went wrong"}
      error = described_class.from_response(body, {})
      expect(error.message).to eq("Something went wrong")
    end

    it "creates error with message from errors array of strings" do
      body = {errors: ["First error\n", "Second error"]}
      error = described_class.from_response(body, {})
      expect(error.message).to eq("First error")
    end

    it "creates error with message and code from errors array of hashes" do
      body = {errors: [{message: "Rate limit exceeded\n", code: 88}]}
      error = described_class.from_response(body, {})
      expect(error.message).to eq("Rate limit exceeded")
      expect(error.code).to eq(88)
    end

    it "handles nil body" do
      error = described_class.from_response(nil, {})
      expect(error.message).to eq("")
    end

    it "handles empty body" do
      error = described_class.from_response("", {})
      expect(error.message).to eq("")
    end

    it "returns nil code for error key body" do
      body = {error: "Something went wrong"}
      error = described_class.from_response(body, {})
      expect(error.code).to be_nil
    end

    it "passes headers to the error for rate limiting" do
      body = {error: "Rate limited"}
      headers = {"x-rate-limit-limit" => "100", "x-rate-limit-remaining" => "0"}
      error = described_class.from_response(body, headers)
      expect(error.rate_limit.limit).to eq(100)
      expect(error.rate_limit.remaining).to eq(0)
    end

    it "returns nil code for nil body" do
      error = described_class.from_response(nil, {})
      expect(error.code).to be_nil
    end

    it "returns nil code for empty body" do
      error = described_class.from_response("", {})
      expect(error.code).to be_nil
    end
  end

  describe ".from_processing_response" do
    it "creates MediaError with message and code" do
      error_hash = {name: "InvalidMedia", message: "Bad media", code: 123}
      error = described_class.from_processing_response(error_hash, {})
      expect(error).to be_a Twitter::Error::InvalidMedia
      expect(error.message).to eq("Bad media")
      expect(error.code).to eq(123)
    end

    it "creates MediaInternalError for InternalError name" do
      error_hash = {name: "InternalError", message: "Internal error", code: 1}
      error = described_class.from_processing_response(error_hash, {})
      expect(error).to be_a Twitter::Error::MediaInternalError
    end

    it "creates UnsupportedMedia for UnsupportedMedia name" do
      error_hash = {name: "UnsupportedMedia", message: "Unsupported", code: 2}
      error = described_class.from_processing_response(error_hash, {})
      expect(error).to be_a Twitter::Error::UnsupportedMedia
    end

    it "falls back to base MediaError for unknown names" do
      error_hash = {name: "UnknownError", message: "Unknown", code: 3}
      error = described_class.from_processing_response(error_hash, {})
      expect(error).to be_a Twitter::Error
    end

    it "passes headers to the error for rate limiting" do
      error_hash = {name: "InvalidMedia", message: "Bad media", code: 123}
      headers = {"x-rate-limit-limit" => "50", "x-rate-limit-remaining" => "49"}
      error = described_class.from_processing_response(error_hash, headers)
      expect(error.rate_limit.limit).to eq(50)
      expect(error.rate_limit.remaining).to eq(49)
    end

    it "extracts message from error hash" do
      error_hash = {name: "InvalidMedia", message: "Specific message", code: 1}
      error = described_class.from_processing_response(error_hash, {})
      expect(error.message).to eq("Specific message")
    end

    it "extracts code from error hash" do
      error_hash = {name: "InvalidMedia", message: "msg", code: 999}
      error = described_class.from_processing_response(error_hash, {})
      expect(error.code).to eq(999)
    end

    it "extracts name from error hash to determine error class" do
      error_hash = {name: "UnsupportedMedia", message: "msg", code: 1}
      error = described_class.from_processing_response(error_hash, {})
      expect(error).to be_a Twitter::Error::UnsupportedMedia
    end

    it "falls back to base error class when :name is missing" do
      error = described_class.from_processing_response({message: "msg", code: 1}, {})

      expect(error).to be_a(Twitter::Error)
      expect(error).not_to be_a(Twitter::Error::MediaError)
    end

    it "allows missing :message without raising" do
      error = described_class.from_processing_response({name: "InvalidMedia", code: 1}, {})

      expect(error).to be_a(Twitter::Error::InvalidMedia)
      expect(error.code).to eq(1)
    end

    it "allows missing :code and sets nil code" do
      error = described_class.from_processing_response({name: "InvalidMedia", message: "Bad media"}, {})

      expect(error).to be_a(Twitter::Error::InvalidMedia)
      expect(error.code).to be_nil
    end
  end

  describe "private parser helpers" do
    describe ".parse_error" do
      it "returns a two-element tuple for empty input" do
        expect(described_class.send(:parse_error, nil)).to eq(["", nil])
      end

      it "prefers :errors when :error key is present with nil value" do
        body = {error: nil, errors: ["From errors\n"]}

        expect(described_class.send(:parse_error, body)).to eq(["From errors", nil])
      end

      it "returns nil when only a nil :errors key is present" do
        expect(described_class.send(:parse_error, {errors: nil})).to be_nil
      end

      it "returns a two-element tuple for :error values" do
        result = described_class.send(:parse_error, {error: "boom"})

        expect(result).to eq(["boom", nil])
        expect(result.length).to eq(2)
      end
    end

    describe ".extract_message_from_errors" do
      it "handles Hash subclasses as error objects" do
        hash_subclass = Class.new(Hash)
        first = hash_subclass[message: "Subclassed\n", code: 7]

        expect(described_class.send(:extract_message_from_errors, {errors: [first]})).to eq(["Subclassed", 7])
      end

      it "raises NoMethodError when :errors key is missing" do
        expect { described_class.send(:extract_message_from_errors, {}) }.to raise_error(NoMethodError)
      end

      it "raises NoMethodError when hash error has no :message key" do
        body = {errors: [{code: 12}]}

        expect { described_class.send(:extract_message_from_errors, body) }.to raise_error(NoMethodError)
      end

      it "returns nil code when hash error has no :code key" do
        result = described_class.send(:extract_message_from_errors, {errors: [{message: "No code\n"}]})

        expect(result).to eq(["No code", nil])
        expect(result.length).to eq(2)
      end

      it "returns a two-element tuple for string errors" do
        result = described_class.send(:extract_message_from_errors, {errors: ["Simple error\n"]})

        expect(result).to eq(["Simple error", nil])
        expect(result.length).to eq(2)
      end
    end
  end

  describe "FORBIDDEN_MESSAGES" do
    it "returns DuplicateStatus for duplicate status message" do
      expect(described_class::FORBIDDEN_MESSAGES["Status is a duplicate."]).to eq Twitter::Error::DuplicateStatus
    end

    it "returns AlreadyFavorited for already favorited message" do
      expect(described_class::FORBIDDEN_MESSAGES["You have already favorited this status."]).to eq Twitter::Error::AlreadyFavorited
    end

    it "returns AlreadyRetweeted for already retweeted message" do
      expect(described_class::FORBIDDEN_MESSAGES["You have already retweeted this Tweet."]).to eq Twitter::Error::AlreadyRetweeted
    end

    it "returns AlreadyRetweeted for share validations failed message" do
      expect(described_class::FORBIDDEN_MESSAGES["sharing is not permissible for this status (Share validations failed)"]).to eq Twitter::Error::AlreadyRetweeted
    end

    it "returns nil for unknown message" do
      expect(described_class::FORBIDDEN_MESSAGES["Some other error"]).to be_nil
    end
  end

  %w[error errors].each do |key|
    context "when JSON body contains #{key}" do
      before do
        body = "{\"#{key}\":\"Internal Server Error\"}"
        stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status: 500, body:, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises an exception with the proper message" do
        expect { @client.user_timeline("sferik") }.to raise_error(Twitter::Error::InternalServerError)
      end
    end
  end

  context "when JSON body contains neither error nor errors" do
    before do
      body = '{"foo":"bar"}'
      stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status: 500, body:, headers: {content_type: "application/json; charset=utf-8"})
    end

    it "raises an exception with empty message" do
      expect { @client.user_timeline("sferik") }.to raise_error(Twitter::Error::InternalServerError)
    end
  end

  Twitter::Error::ERRORS.each do |status, exception|
    context "when HTTP status is #{status}" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(status:, body: "{}", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises #{exception}" do
        expect { @client.user_timeline("sferik") }.to raise_error(exception)
      end
    end
  end
end
