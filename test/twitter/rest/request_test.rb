require "helper"

describe Twitter::REST::Request do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe ".new" do
    it "sets up the request with options" do
      request = described_class.new(@client, :get, "/1.1/test.json", {foo: "bar"})
      expect(request.uri.to_s).to eq("https://api.twitter.com/1.1/test.json")
      expect(request.verb).to eq(:get)
    end

    it "handles full URLs" do
      request = described_class.new(@client, :get, "https://custom.twitter.com/test.json", {})
      expect(request.uri.to_s).to eq("https://custom.twitter.com/test.json")
    end

    it "sets client" do
      request = described_class.new(@client, :get, "/test.json", {})
      expect(request.client).to eq(@client)
    end

    it "sets path from URI" do
      request = described_class.new(@client, :get, "/1.1/path/test.json", {})
      expect(request.path).to eq("/1.1/path/test.json")
    end

    it "sets options" do
      options = {foo: "bar", baz: "qux"}
      request = described_class.new(@client, :get, "/test.json", options)
      expect(request.options).to eq(options)
    end

    it "sets headers" do
      request = described_class.new(@client, :get, "/test.json", {})
      expect(request.headers).to be_a(Hash)
      expect(request.headers[:user_agent]).not_to be_nil
    end

    it "handles json_post request method" do
      request = described_class.new(@client, :json_post, "/test.json", {foo: "bar"})
      expect(request.request_method).to eq(:post)
    end

    it "handles json_put request method" do
      request = described_class.new(@client, :json_put, "/test.json", {foo: "bar"})
      expect(request.request_method).to eq(:put)
    end

    it "handles delete request method" do
      request = described_class.new(@client, :delete, "/test.json", {foo: "bar"})
      expect(request.request_method).to eq(:delete)
    end

    it "handles params parameter" do
      request = described_class.new(@client, :get, "/test.json", {opt: "val"}, {param: "value"})
      expect(request.options).to eq({opt: "val"})
    end

    it "sets path from full URL" do
      request = described_class.new(@client, :get, "https://custom.twitter.com/custom/path.json", {})
      expect(request.path).to eq("/custom/path.json")
    end

    it "defaults options to empty hash" do
      request = described_class.new(@client, :get, "/test.json")
      expect(request.options).to eq({})
    end

    it "uses Addressable::URI for parsing (supports unicode)" do
      request = described_class.new(@client, :get, "https://example.com/test%20path.json", {})
      expect(request.uri).to be_a(Addressable::URI)
      expect(request.uri.to_s).to include("test%20path")
    end
  end

  describe "#request" do
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      expect_any_instance_of(HTTP::Client).to receive(:post).with("https://api.twitter.com/1.1/statuses/update.json", form: instance_of(HTTP::FormData::Urlencoded)).and_call_original
      @client.update("Update")
      expect(a_post("/1.1/statuses/update.json").with(body: {status: "Update"})).to have_been_made
    end

    it "encodes none of the body when uploaded media is present" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("pbjt.gif"))
      expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
      expect(a_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"})).to have_been_made
    end

    it "uses custom HTTP::FormData::Urlencoded instance for form requests" do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      expect_any_instance_of(HTTP::Client).to receive(:post).with("https://api.twitter.com/1.1/statuses/update.json", form: instance_of(HTTP::FormData::Urlencoded)).and_call_original
      expect(Twitter::REST::FormEncoder).to receive(:encode).with({status: "Update"}).and_call_original
      @client.update("Update")
    end

    context "when using a proxy" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", proxy: {host: "127.0.0.1", port: 3328})
      end

      it "requests via the proxy when no uploaded media is present" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).to receive(:via).with("127.0.0.1", 3328).and_call_original
        @client.update("Update")
      end

      it "requests via the proxy when uploaded media is present" do
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).to receive(:via).with("127.0.0.1", 3328).twice.and_call_original
        @client.update_with_media("Update", fixture("pbjt.gif"))
      end

      context "when using timeout options" do
        before do
          @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", proxy: {host: "127.0.0.1", port: 3328}, timeouts: {connect: 2, read: 2, write: 3})
        end

        it "requests with given timeout settings" do
          stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
          expect_any_instance_of(HTTP::Client).to receive(:timeout).with(connect: 2, read: 2, write: 3).and_call_original
          @client.update("Update")
        end
      end
    end

    context "when using timeout options" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: {connect: 2, read: 2, write: 3})
      end

      it "requests with given timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).to receive(:timeout).with(connect: 2, read: 2, write: 3).and_call_original
        @client.update("Update")
      end
    end

    context "when timeout keys are incomplete" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: {connect: 2, read: 2})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).not_to receive(:timeout)
        @client.update("Update")
      end
    end

    context "when timeouts are nil" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: nil)
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).not_to receive(:timeout)
        @client.update("Update")
      end
    end

    context "when only connect and read keys are present (missing write)" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: {connect: 2, read: 2})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).not_to receive(:timeout)
        @client.update("Update")
      end
    end

    context "when only connect and write keys are present (missing read)" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: {connect: 2, write: 3})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).not_to receive(:timeout)
        @client.update("Update")
      end
    end

    context "when only read and write keys are present (missing connect)" do
      before do
        @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", timeouts: {read: 2, write: 3})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        expect(HTTP).not_to receive(:timeout)
        @client.update("Update")
      end
    end

    it "returns empty string for empty response body" do
      stub_get("/1.1/test.json").to_return(body: "", headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      expect(result).to eq("")
    end

    it "sets rate_limit on successful requests" do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(
        body: fixture("status.json"),
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "15",
          "x-rate-limit-remaining" => "14",
          "x-rate-limit-reset" => "1234567890"
        }
      )
      request = described_class.new(@client, :post, "/1.1/statuses/update.json", {status: "Update"})
      request.perform
      expect(request.rate_limit).to be_a(Twitter::RateLimit)
      expect(request.rate_limit.limit).to eq(15)
    end

    it "extracts headers from response (not the response itself)" do
      stub_get("/1.1/test.json").to_return(
        body: '{"success": true}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "100",
          "x-rate-limit-remaining" => "99",
          "x-rate-limit-reset" => "1234567890"
        }
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      request.perform
      # Rate limit should be created from headers, which contain specific rate limit info
      # If response was passed instead of response.headers, RateLimit would fail or have wrong values
      expect(request.rate_limit.limit).to eq(100)
      expect(request.rate_limit.remaining).to eq(99)
    end

    it "uses response.headers not response for fail_or_return_response_body" do
      stub_get("/1.1/test.json").to_return(
        status: 404,
        body: '{"errors": [{"message": "Not Found", "code": 34}]}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "150",
          "x-rate-limit-remaining" => "149",
          "x-rate-limit-reset" => "9876543210"
        }
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        # Verify headers are passed to Error.from_response, which creates RateLimit from headers
        # If the full response was passed instead of response.headers, rate_limit would not have correct values
        expect(e.rate_limit.limit).to eq(150)
        expect(e.rate_limit.remaining).to eq(149)
      end
    end

    it "symbolizes keys in response body hashes" do
      stub_get("/1.1/test.json").to_return(
        body: '{"string_key": "value", "nested": {"inner_key": "inner_value"}}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      expect(result).to have_key(:string_key)
      expect(result).to have_key(:nested)
      expect(result[:nested]).to have_key(:inner_key)
    end

    it "symbolizes keys in response body arrays" do
      stub_get("/1.1/test.json").to_return(
        body: '[{"key1": "value1"}, {"key2": "value2"}]',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      expect(result).to be_an(Array)
      expect(result[0]).to have_key(:key1)
      expect(result[1]).to have_key(:key2)
    end

    it "returns modified array with symbolized keys when array contains nested hashes" do
      stub_get("/1.1/test.json").to_return(
        body: '[{"outer_key": {"inner_key": "value"}}]',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      # This test verifies that the return value of symbolize_keys! is assigned back to the array
      expect(result[0]).to have_key(:outer_key)
      expect(result[0][:outer_key]).to have_key(:inner_key)
      # The nested hash should also have symbolized keys
      expect(result[0][:outer_key][:inner_key]).to eq("value")
    end

    it "modifies array elements in place with symbolized values" do
      stub_get("/1.1/test.json").to_return(
        body: '[[{"nested_key": "nested_value"}]]',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      # Array within array - the inner array should have its hash symbolized
      expect(result[0][0]).to have_key(:nested_key)
    end

    it "handles GET requests with params" do
      stub_get("/1.1/test.json").with(query: {foo: "bar"}).to_return(
        body: '{"success": true}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {foo: "bar"})
      result = request.perform
      expect(result[:success]).to be true
    end

    it "passes headers to the HTTP client" do
      stub_get("/1.1/test.json").to_return(
        body: '{"success": true}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})

      # Verify headers are set and include expected keys
      expect(request.headers).to be_a(Hash)
      expect(request.headers[:user_agent]).not_to be_nil
      expect(request.headers[:authorization]).not_to be_nil

      # Verify headers are used in the request
      expect(HTTP).to receive(:headers).with(request.headers).and_call_original
      request.perform
    end

    it "handles DELETE requests with params" do
      stub_delete("/1.1/test.json").with(query: {id: "123"}).to_return(
        body: '{"deleted": true}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :delete, "/1.1/test.json", {id: "123"})
      result = request.perform
      expect(result[:deleted]).to be true
    end

    context "with json_post request" do
      it "sends JSON body" do
        stub_post("/1.1/test.json").to_return(
          body: '{"success": true}',
          headers: {content_type: "application/json; charset=utf-8"}
        )
        request = described_class.new(@client, :json_post, "/1.1/test.json", {data: "value"})
        result = request.perform
        expect(result[:success]).to be true
      end

      it "uses :json as the options key for json_post" do
        stub_post("/1.1/test.json").to_return(
          body: '{"received": true}',
          headers: {content_type: "application/json; charset=utf-8"}
        )
        expect_any_instance_of(HTTP::Client).to receive(:post).with(
          "https://api.twitter.com/1.1/test.json",
          hash_including(json: {data: "value"})
        ).and_call_original
        request = described_class.new(@client, :json_post, "/1.1/test.json", {data: "value"})
        request.perform
      end
    end

    context "with json_put request" do
      it "sends JSON body" do
        stub_put("/1.1/test.json").to_return(
          body: '{"success": true}',
          headers: {content_type: "application/json; charset=utf-8"}
        )
        request = described_class.new(@client, :json_put, "/1.1/test.json", {data: "value"})
        result = request.perform
        expect(result[:success]).to be true
      end

      it "uses :json as the options key for json_put" do
        stub_put("/1.1/test.json").to_return(
          body: '{"received": true}',
          headers: {content_type: "application/json; charset=utf-8"}
        )
        expect_any_instance_of(HTTP::Client).to receive(:put).with(
          "https://api.twitter.com/1.1/test.json",
          hash_including(json: {data: "value"})
        ).and_call_original
        request = described_class.new(@client, :json_put, "/1.1/test.json", {data: "value"})
        request.perform
      end
    end

    context "with params as separate argument" do
      it "sends both form data and query params" do
        stub_post("/1.1/test.json").with(query: {query_param: "qval"}).to_return(
          body: '{"success": true}',
          headers: {content_type: "application/json; charset=utf-8"}
        )
        request = described_class.new(@client, :post, "/1.1/test.json", {form_data: "fval"}, {query_param: "qval"})
        result = request.perform
        expect(result[:success]).to be true
      end
    end
  end

  describe "error handling" do
    it "raises BadRequest for 400 status" do
      stub_get("/1.1/test.json").to_return(status: 400, body: '{"errors": [{"message": "Bad Request", "code": 1}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::BadRequest)
    end

    it "raises Unauthorized for 401 status" do
      stub_get("/1.1/test.json").to_return(status: 401, body: '{"errors": [{"message": "Unauthorized", "code": 32}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::Unauthorized)
    end

    it "raises Forbidden for 403 status" do
      stub_get("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Forbidden", "code": 1}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::Forbidden)
    end

    it "raises NotFound for 404 status" do
      stub_get("/1.1/test.json").to_return(status: 404, body: '{"errors": [{"message": "Not Found", "code": 34}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::NotFound)
    end

    it "raises TooManyRequests for 429 status" do
      stub_get("/1.1/test.json").to_return(status: 429, body: '{"errors": [{"message": "Rate limit exceeded", "code": 88}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::TooManyRequests)
    end

    it "raises InternalServerError for 500 status" do
      stub_get("/1.1/test.json").to_return(status: 500, body: '{"errors": [{"message": "Internal Error", "code": 131}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::InternalServerError)
    end

    it "raises BadGateway for 502 status" do
      stub_get("/1.1/test.json").to_return(status: 502, body: '{"errors": [{"message": "Bad Gateway"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::BadGateway)
    end

    it "raises ServiceUnavailable for 503 status" do
      stub_get("/1.1/test.json").to_return(status: 503, body: '{"errors": [{"message": "Service Unavailable"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::ServiceUnavailable)
    end

    it "raises GatewayTimeout for 504 status" do
      stub_get("/1.1/test.json").to_return(status: 504, body: '{"errors": [{"message": "Gateway Timeout"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::GatewayTimeout)
    end

    it "raises DuplicateStatus for duplicate status forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Status is a duplicate.", "code": 187}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::DuplicateStatus)
    end

    it "raises AlreadyFavorited for already favorited forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "You have already favorited this status.", "code": 139}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::AlreadyFavorited)
    end

    it "raises AlreadyRetweeted for already retweeted forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "You have already retweeted this Tweet.", "code": 327}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::AlreadyRetweeted)
    end

    it "raises AlreadyRetweeted for share validations failed error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Share validations failed", "code": 327}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::AlreadyRetweeted)
    end

    it "passes headers to DuplicateStatus error" do
      stub_post("/1.1/test.json").to_return(
        status: 403,
        body: '{"errors": [{"message": "Status is a duplicate.", "code": 187}]}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "15",
          "x-rate-limit-remaining" => "0",
          "x-rate-limit-reset" => "1234567890"
        }
      )
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::DuplicateStatus => e
        expect(e.rate_limit).to be_a(Twitter::RateLimit)
        expect(e.rate_limit.limit).to eq(15)
      end
    end

    it "passes headers to Forbidden error when no specific message matches" do
      stub_post("/1.1/test.json").to_return(
        status: 403,
        body: '{"errors": [{"message": "Some generic forbidden error", "code": 1}]}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "20",
          "x-rate-limit-remaining" => "5",
          "x-rate-limit-reset" => "1234567890"
        }
      )
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::Forbidden => e
        expect(e.rate_limit).to be_a(Twitter::RateLimit)
        expect(e.rate_limit.limit).to eq(20)
      end
    end

    it "passes headers to non-forbidden errors" do
      stub_get("/1.1/test.json").to_return(
        status: 404,
        body: '{"errors": [{"message": "Not Found", "code": 34}]}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "30",
          "x-rate-limit-remaining" => "29",
          "x-rate-limit-reset" => "1234567890"
        }
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        expect(e.rate_limit).to be_a(Twitter::RateLimit)
        expect(e.rate_limit.limit).to eq(30)
      end
    end

    it "passes body to error for non-forbidden errors" do
      stub_get("/1.1/test.json").to_return(
        status: 404,
        body: '{"errors": [{"message": "Resource not found", "code": 34}]}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        expect(e.message).to eq("Resource not found")
        expect(e.code).to eq(34)
      end
    end

    it "passes body to error for forbidden errors with specific message" do
      stub_post("/1.1/test.json").to_return(
        status: 403,
        body: '{"errors": [{"message": "Status is a duplicate.", "code": 187}]}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::DuplicateStatus => e
        expect(e.message).to eq("Status is a duplicate.")
        expect(e.code).to eq(187)
      end
    end

    it "passes headers to MediaError" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "InvalidMedia", "message": "Invalid media format", "code": 100}}}',
        headers: {
          :content_type => "application/json; charset=utf-8",
          "x-rate-limit-limit" => "25"
        }
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::InvalidMedia => e
        expect(e.message).to eq("Invalid media format")
        expect(e.rate_limit.limit).to eq(25)
      end
    end

    it "raises MediaError for processing info error" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "InvalidMedia", "message": "Invalid media", "code": 1}}}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::InvalidMedia)
    end

    it "raises MediaError for UnsupportedMedia" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "UnsupportedMedia", "message": "Unsupported media", "code": 2}}}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::UnsupportedMedia)
    end

    it "raises MediaInternalError for InternalError" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "InternalError", "message": "Internal error", "code": 3}}}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::MediaInternalError)
    end

    it "raises generic MediaError for unknown media error name" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "UnknownError", "message": "Unknown error", "code": 99}}}',
        headers: {content_type: "application/json; charset=utf-8"}
      )
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::MediaError)
    end

    it "does not raise error for 200 status" do
      stub_get("/1.1/test.json").to_return(status: 200, body: '{"success": true}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.not_to raise_error
    end

    it "does not raise error for unknown status codes" do
      stub_get("/1.1/test.json").to_return(status: 201, body: '{"created": true}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.not_to raise_error
    end

    it "raises NotAcceptable for 406 status" do
      stub_get("/1.1/test.json").to_return(status: 406, body: '{"errors": [{"message": "Not Acceptable"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::NotAcceptable)
    end

    it "raises RequestEntityTooLarge for 413 status" do
      stub_get("/1.1/test.json").to_return(status: 413, body: '{"errors": [{"message": "Request Entity Too Large"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::RequestEntityTooLarge)
    end

    it "raises UnprocessableEntity for 422 status" do
      stub_get("/1.1/test.json").to_return(status: 422, body: '{"errors": [{"message": "Unprocessable Entity"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::UnprocessableEntity)
    end

    it "raises TooManyRequests for 420 status" do
      stub_get("/1.1/test.json").to_return(status: 420, body: '{"errors": [{"message": "Rate limit exceeded"}]}', headers: {content_type: "application/json; charset=utf-8"})
      request = described_class.new(@client, :get, "/1.1/test.json", {})
      expect { request.perform }.to raise_error(Twitter::Error::TooManyRequests)
    end
  end

  describe "multipart uploads" do
    it "handles file uploads with GIF content type" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("pbjt.gif"))
      expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
    end

    it "handles file uploads with JPEG content type" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("me.jpeg"))
      expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
    end

    it "handles StringIO uploads with video/mp4 content type" do
      # Test content_type detection for StringIO files directly
      request = described_class.new(@client, :multipart_post, "https://upload.twitter.com/1.1/media/upload.json", {}, {key: :media, file: StringIO.new("fake video data")})
      expect(request.request_method).to eq(:post)
    end

    context "file content type detection" do
      # Test content_type method directly using send
      it "returns image/gif for .gif files" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.gif")).to eq("image/gif")
      end

      it "returns image/gif for .GIF files (case insensitive)" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "TEST.GIF")).to eq("image/gif")
      end

      it "returns image/jpeg for .jpg files" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.jpg")).to eq("image/jpeg")
      end

      it "returns image/jpeg for .jpeg files" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.jpeg")).to eq("image/jpeg")
      end

      it "returns image/jpeg for .JPG files (case insensitive)" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "TEST.JPG")).to eq("image/jpeg")
      end

      it "returns image/jpeg for .JPEG files (case insensitive)" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "TEST.JPEG")).to eq("image/jpeg")
      end

      it "returns image/jpeg for .jpEg files (mixed case)" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.jpEg")).to eq("image/jpeg")
      end

      it "returns image/png for .png files" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.png")).to eq("image/png")
      end

      it "returns image/png for .PNG files (case insensitive)" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "TEST.PNG")).to eq("image/png")
      end

      it "returns application/octet-stream for unknown file types" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.bin")).to eq("application/octet-stream")
      end

      it "returns application/octet-stream for .mp4 files" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "test.mp4")).to eq("application/octet-stream")
      end

      it "returns application/octet-stream for files without extension" do
        request = described_class.new(@client, :get, "/test.json", {})
        expect(request.send(:content_type, "testfile")).to eq("application/octet-stream")
      end
    end
  end

  describe "#set_multipart_options!" do
    let(:temp_dir) { Dir.mktmpdir }

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it "sets request_method to :post for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      request = described_class.new(@client, :multipart_post, "/test.json", {}, {key: :media, file: file})
      expect(request.request_method).to eq(:post)
      file.close
    end

    it "sets request_method to :post for :json_post" do
      request = described_class.new(@client, :json_post, "/test.json", {data: "value"})
      expect(request.request_method).to eq(:post)
    end

    it "sets request_method to :put for :json_put" do
      request = described_class.new(@client, :json_put, "/test.json", {data: "value"})
      expect(request.request_method).to eq(:put)
    end

    it "keeps request_method for :get" do
      request = described_class.new(@client, :get, "/test.json", {})
      expect(request.request_method).to eq(:get)
    end

    it "keeps request_method for :delete" do
      request = described_class.new(@client, :delete, "/test.json", {})
      expect(request.request_method).to eq(:delete)
    end

    it "keeps request_method for :post" do
      request = described_class.new(@client, :post, "/test.json", {})
      expect(request.request_method).to eq(:post)
    end

    it "calls merge_multipart_file! for :multipart_post but not for :json_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      params = {key: :media, file: file}

      # For multipart_post, the params should have :media set to HTTP::FormData::File
      described_class.new(@client, :multipart_post, "/test.json", {}, params)

      # After initialization, the params should have been modified
      expect(params[:media]).to be_a(HTTP::FormData::File)
      expect(params).not_to have_key(:key)
      expect(params).not_to have_key(:file)
      file.close
    end

    it "does not modify params for :json_post" do
      params = {key: :media, file: "should_remain"}

      described_class.new(@client, :json_post, "/test.json", {}, params)

      # params should remain unchanged
      expect(params[:key]).to eq(:media)
      expect(params[:file]).to eq("should_remain")
    end

    it "creates headers with empty options for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)

      # Headers should be created with empty options hash for multipart_post
      request = described_class.new(@client, :multipart_post, "/test.json", {will_be_ignored: true}, {key: :media, file: file})

      # The headers are created and the request method should be :post
      expect(request.headers).to be_a(Hash)
      expect(request.request_method).to eq(:post)
      file.close
    end

    it "creates headers with empty options for :json_post" do
      request = described_class.new(@client, :json_post, "/test.json", {will_be_ignored: true})
      expect(request.headers).to be_a(Hash)
      expect(request.request_method).to eq(:post)
    end

    it "passes client to Headers.new" do
      expect(Twitter::Headers).to receive(:new).with(@client, anything, anything, anything).and_call_original
      described_class.new(@client, :get, "/test.json", {})
    end

    it "passes request_method to Headers.new" do
      expect(Twitter::Headers).to receive(:new).with(anything, :get, anything, anything).and_call_original
      described_class.new(@client, :get, "/test.json", {})
    end

    it "passes transformed request_method :post to Headers.new for :json_post" do
      expect(Twitter::Headers).to receive(:new).with(anything, :post, anything, anything).and_call_original
      described_class.new(@client, :json_post, "/test.json", {})
    end

    it "passes uri to Headers.new" do
      expect(Twitter::Headers).to receive(:new) do |_client, _method, uri, _opts|
        expect(uri).to be_a(Addressable::URI)
        expect(uri.to_s).to eq("https://api.twitter.com/test.json")
        instance_double(Twitter::Headers, request_headers: {})
      end
      described_class.new(@client, :get, "/test.json", {})
    end

    it "passes empty options to Headers.new for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)

      expect(Twitter::Headers).to receive(:new).with(anything, anything, anything, {}).and_call_original
      described_class.new(@client, :multipart_post, "/test.json", {will_be_ignored: true}, {key: :media, file: file})
      file.close
    end

    it "passes options to Headers.new for regular requests" do
      options = {foo: "bar"}
      expect(Twitter::Headers).to receive(:new).with(anything, anything, anything, options).and_call_original
      described_class.new(@client, :get, "/test.json", options)
    end
  end

  describe "#merge_multipart_file!" do
    let(:temp_dir) { Dir.mktmpdir }

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it "removes :key from options and sets it as the key for the file" do
      request = described_class.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options).not_to have_key(:key)
      expect(options).not_to have_key(:file)
      expect(options[:media]).to be_a(HTTP::FormData::File)
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for gif" do
      request = described_class.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options[:media].content_type).to eq("image/gif")
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for jpeg" do
      request = described_class.new(@client, :get, "/test.json", {})
      jpg_file = File.join(temp_dir, "test.jpg")
      File.write(jpg_file, "\xFF\xD8\xFF")
      file = File.new(jpg_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options[:media].content_type).to eq("image/jpeg")
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for png" do
      request = described_class.new(@client, :get, "/test.json", {})
      png_file = File.join(temp_dir, "test.png")
      File.write(png_file, "\x89PNG")
      file = File.new(png_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options[:media].content_type).to eq("image/png")
      file.close
    end

    it "creates HTTP::FormData::File with correct filename for regular files" do
      request = described_class.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "myimage.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      # Verify that filename parameter is used
      expect(options[:media].filename).to eq("myimage.gif")
      # Verify a different filename to ensure it's not defaulting
      expect(options[:media].filename).not_to eq("test.gif")
      file.close
    end

    it "passes filename to HTTP::FormData::File.new (not just file path)" do
      request = described_class.new(@client, :get, "/test.json", {})
      unique_name = "unique_#{Time.now.to_i}.gif"
      gif_file = File.join(temp_dir, unique_name)
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      # Verify filename is explicitly set by checking it matches File.basename
      expect(HTTP::FormData::File).to receive(:new).with(
        file,
        hash_including(filename: unique_name, content_type: "image/gif")
      ).and_call_original

      request.send(:merge_multipart_file!, options)
      file.close
    end

    it "uses the file object for regular file uploads" do
      request = described_class.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "data.gif")
      File.write(gif_file, "GIF89a content here")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      # Verify the file content is used (size matches file size)
      expect(options[:media].size).to eq("GIF89a content here".length)
      file.close
    end

    it "handles StringIO files with video/mp4 content type" do
      request = described_class.new(@client, :get, "/test.json", {})
      string_io = StringIO.new("video data")
      options = {key: :media, file: string_io}

      request.send(:merge_multipart_file!, options)

      expect(options[:media]).to be_a(HTTP::FormData::File)
      expect(options[:media].content_type).to eq("video/mp4")
      # Verify the file content is actually used (size > 0)
      expect(options[:media].size).to eq(10) # "video data".length
    end

    it "sets application/octet-stream for unknown file types" do
      request = described_class.new(@client, :get, "/test.json", {})
      bin_file = File.join(temp_dir, "test.bin")
      File.write(bin_file, "binary data")
      file = File.new(bin_file)
      options = {key: :data, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options[:data]).to be_a(HTTP::FormData::File)
      expect(options[:data].content_type).to eq("application/octet-stream")
      file.close
    end

    it "uses the correct key from options" do
      request = described_class.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :custom_key, file: file}

      request.send(:merge_multipart_file!, options)

      expect(options).to have_key(:custom_key)
      expect(options[:custom_key]).to be_a(HTTP::FormData::File)
      file.close
    end
  end

  describe "proxy configuration" do
    it "uses proxy with username and password" do
      client = Twitter::REST::Client.new(
        consumer_key: "CK",
        consumer_secret: "CS",
        access_token: "AT",
        access_token_secret: "AS",
        proxy: {host: "127.0.0.1", port: 3328, username: "user", password: "pass"}
      )
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      expect(HTTP).to receive(:via).with("127.0.0.1", 3328, "user", "pass").and_call_original
      client.update("Update")
    end

    it "uses proxy with only username" do
      client = Twitter::REST::Client.new(
        consumer_key: "CK",
        consumer_secret: "CS",
        access_token: "AT",
        access_token_secret: "AS",
        proxy: {host: "127.0.0.1", port: 3328, username: "user"}
      )
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      expect(HTTP).to receive(:via).with("127.0.0.1", 3328, "user").and_call_original
      client.update("Update")
    end
  end
end
