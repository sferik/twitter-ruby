require "test_helper"

describe Twitter::REST::Request do
  before do
    @client = build_rest_client
  end

  describe ".new" do
    it "sets up the request with options" do
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {foo: "bar"})

      assert_equal("https://api.twitter.com/1.1/test.json", request.uri.to_s)
      assert_equal(:get, request.verb)
    end

    it "handles full URLs" do
      request = Twitter::REST::Request.new(@client, :get, "https://custom.twitter.com/test.json", {})

      assert_equal("https://custom.twitter.com/test.json", request.uri.to_s)
    end

    it "sets client" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

      assert_equal(@client, request.client)
    end

    it "sets path from URI" do
      request = Twitter::REST::Request.new(@client, :get, "/1.1/path/test.json", {})

      assert_equal("/1.1/path/test.json", request.path)
    end

    it "sets options" do
      options = {foo: "bar", baz: "qux"}
      request = Twitter::REST::Request.new(@client, :get, "/test.json", options)

      assert_equal(options, request.options)
    end

    it "sets headers" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

      assert_kind_of(Hash, request.headers)
      refute_nil(request.headers[:user_agent])
    end

    it "handles json_post request method" do
      request = Twitter::REST::Request.new(@client, :json_post, "/test.json", {foo: "bar"})

      assert_equal(:post, request.request_method)
    end

    it "handles json_put request method" do
      request = Twitter::REST::Request.new(@client, :json_put, "/test.json", {foo: "bar"})

      assert_equal(:put, request.request_method)
    end

    it "handles delete request method" do
      request = Twitter::REST::Request.new(@client, :delete, "/test.json", {foo: "bar"})

      assert_equal(:delete, request.request_method)
    end

    it "handles params parameter" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {opt: "val"}, {param: "value"})

      assert_equal({opt: "val"}, request.options)
    end

    it "sets path from full URL" do
      request = Twitter::REST::Request.new(@client, :get, "https://custom.twitter.com/custom/path.json", {})

      assert_equal("/custom/path.json", request.path)
    end

    it "defaults options to empty hash" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json")

      assert_empty(request.options)
    end

    it "uses Addressable::URI for parsing (supports unicode)" do
      request = Twitter::REST::Request.new(@client, :get, "https://example.com/test%20path.json", {})

      assert_kind_of(Addressable::URI, request.uri)
      assert_includes(request.uri.to_s, "test%20path")
    end
  end

  describe "#request" do
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/statuses/update.json", {status: "Update"})

      assert_kind_of(HTTP::FormData::Urlencoded, request.send(:request_options)[:form])
      @client.update("Update")

      assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Update"}))
    end

    it "encodes none of the body when uploaded media is present" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"}).to_return(body: fixture("status.json"), headers: json_headers)
      @client.update_with_media("Update", fixture_file("pbjt.gif"))

      assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
      assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"}))
    end

    it "uses custom HTTP::FormData::Urlencoded instance for form requests" do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/statuses/update.json", {status: "Update"})

      assert_kind_of(HTTP::FormData::Urlencoded, request.send(:request_options)[:form])

      encoded_query = nil
      original_encode = Twitter::REST::FormEncoder.method(:encode)
      Twitter::REST::FormEncoder.stub(:encode, lambda { |query|
        encoded_query = query
        original_encode.call(query)
      }) do
        @client.update("Update")
      end

      assert_equal({status: "Update"}, encoded_query)
    end

    describe "when using a proxy" do
      before do
        @client = build_rest_client(proxy: {host: "127.0.0.1", port: 3328})
      end

      it "requests via the proxy when no uploaded media is present" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        original_via = HTTP.method(:via)
        via_args = []

        HTTP.stub(:via, lambda { |*args|
          via_args << args
          original_via.call(*args)
        }) do
          @client.update("Update")
        end

        assert_equal([["127.0.0.1", 3328]], via_args)
      end

      it "requests via the proxy when uploaded media is present" do
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update", media_ids: "470030289822314497"}).to_return(body: fixture("status.json"), headers: json_headers)
        original_via = HTTP.method(:via)
        via_args = []

        HTTP.stub(:via, lambda { |*args|
          via_args << args
          original_via.call(*args)
        }) do
          @client.update_with_media("Update", fixture_file("pbjt.gif"))
        end

        assert_equal(2, via_args.length)
        assert_equal(["127.0.0.1", 3328], via_args[0])
        assert_equal(["127.0.0.1", 3328], via_args[1])
      end

      describe "when using timeout options" do
        before do
          @client = build_rest_client(proxy: {host: "127.0.0.1", port: 3328}, timeouts: {connect: 2, read: 2, write: 3})
        end

        it "requests with given timeout settings" do
          stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
          original_via = HTTP.method(:via)
          timeout_calls = []

          HTTP.stub(:via, lambda { |*args|
            client = original_via.call(*args)
            original_timeout = client.method(:timeout)
            client.define_singleton_method(:timeout) do |**options|
              timeout_calls << options
              original_timeout.call(**options)
            end
            client
          }) do
            @client.update("Update")
          end

          assert_equal([{connect: 2, read: 2, write: 3}], timeout_calls)
        end
      end
    end

    describe "when using timeout options" do
      before do
        @client = build_rest_client(timeouts: {connect: 2, read: 2, write: 3})
      end

      it "requests with given timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        original_timeout = HTTP.method(:timeout)
        timeout_calls = []

        HTTP.stub(:timeout, lambda { |**options|
          timeout_calls << options
          original_timeout.call(**options)
        }) do
          @client.update("Update")
        end

        assert_equal([{connect: 2, read: 2, write: 3}], timeout_calls)
      end
    end

    describe "when timeout keys are incomplete" do
      before do
        @client = build_rest_client(timeouts: {connect: 2, read: 2})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        HTTP.stub(:timeout, ->(**_options) { flunk("HTTP.timeout should not be called") }) do
          @client.update("Update")
        end
      end
    end

    describe "when timeouts are nil" do
      before do
        @client = build_rest_client(timeouts: nil)
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        HTTP.stub(:timeout, ->(**_options) { flunk("HTTP.timeout should not be called") }) do
          @client.update("Update")
        end
      end
    end

    describe "when only connect and read keys are present (missing write)" do
      before do
        @client = build_rest_client(timeouts: {connect: 2, read: 2})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        HTTP.stub(:timeout, ->(**_options) { flunk("HTTP.timeout should not be called") }) do
          @client.update("Update")
        end
      end
    end

    describe "when only connect and write keys are present (missing read)" do
      before do
        @client = build_rest_client(timeouts: {connect: 2, write: 3})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        HTTP.stub(:timeout, ->(**_options) { flunk("HTTP.timeout should not be called") }) do
          @client.update("Update")
        end
      end
    end

    describe "when only read and write keys are present (missing connect)" do
      before do
        @client = build_rest_client(timeouts: {read: 2, write: 3})
      end

      it "does not apply timeout settings" do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
        HTTP.stub(:timeout, ->(**_options) { flunk("HTTP.timeout should not be called") }) do
          @client.update("Update")
        end
      end
    end

    it "returns empty string for empty response body" do
      stub_get("/1.1/test.json").to_return(body: "", headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      result = request.perform

      assert_equal("", result)
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
      request = Twitter::REST::Request.new(@client, :post, "/1.1/statuses/update.json", {status: "Update"})
      request.perform

      assert_kind_of(Twitter::RateLimit, request.rate_limit)
      assert_equal(15, request.rate_limit.limit)
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
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      request.perform
      # Rate limit should be created from headers, which contain specific rate limit info
      # If response was passed instead of response.headers, RateLimit would fail or have wrong values
      assert_equal(100, request.rate_limit.limit)
      assert_equal(99, request.rate_limit.remaining)
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
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        # Verify headers are passed to Error.from_response, which creates RateLimit from headers
        # If the full response was passed instead of response.headers, rate_limit would not have correct values
        assert_equal(150, e.rate_limit.limit)
        assert_equal(149, e.rate_limit.remaining)
      end
    end

    it "symbolizes keys in response body hashes" do
      stub_get("/1.1/test.json").to_return(
        body: '{"string_key": "value", "nested": {"inner_key": "inner_value"}}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      result = request.perform

      assert_operator(result, :key?, :string_key)
      assert_operator(result, :key?, :nested)
      assert_operator(result[:nested], :key?, :inner_key)
    end

    it "symbolizes keys in response body arrays" do
      stub_get("/1.1/test.json").to_return(
        body: '[{"key1": "value1"}, {"key2": "value2"}]',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      result = request.perform

      assert_kind_of(Array, result)
      assert_operator(result[0], :key?, :key1)
      assert_operator(result[1], :key?, :key2)
    end

    it "returns modified array with symbolized keys when array contains nested hashes" do
      stub_get("/1.1/test.json").to_return(
        body: '[{"outer_key": {"inner_key": "value"}}]',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      # This test verifies that the return value of symbolize_keys! is assigned back to the array
      assert_operator(result[0], :key?, :outer_key)
      assert_operator(result[0][:outer_key], :key?, :inner_key)
      # The nested hash should also have symbolized keys
      assert_equal("value", result[0][:outer_key][:inner_key])
    end

    it "modifies array elements in place with symbolized values" do
      stub_get("/1.1/test.json").to_return(
        body: '[[{"nested_key": "nested_value"}]]',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      result = request.perform
      # Array within array - the inner array should have its hash symbolized
      assert_operator(result[0][0], :key?, :nested_key)
    end

    it "handles GET requests with params" do
      stub_get("/1.1/test.json").with(query: {foo: "bar"}).to_return(
        body: '{"success": true}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {foo: "bar"})
      result = request.perform

      assert(result[:success])
    end

    it "passes a String URL to HTTP client methods" do
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      response = Object.new
      response.define_singleton_method(:body) { "" }
      response.define_singleton_method(:code) { 200 }
      captured_url = nil

      fake_client = Object.new
      fake_client.define_singleton_method(:headers) do |_headers|
        self
      end
      fake_client.define_singleton_method(:get) do |url, _options|
        captured_url = url
        response
      end

      request.stub(:http_client, fake_client) do
        request.stub(:fail_or_return_response_body, ->(_code, _body, _response) { :ok }) do
          assert_equal(:ok, request.perform)
        end
      end

      assert_kind_of(String, captured_url)
      assert_equal("https://api.twitter.com/1.1/test.json", captured_url)
    end

    it "passes headers to the HTTP client" do
      stub_get("/1.1/test.json").to_return(
        body: '{"success": true}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})

      # Verify headers are set and include expected keys
      assert_kind_of(Hash, request.headers)
      refute_nil(request.headers[:user_agent])
      refute_nil(request.headers[:authorization])

      # Verify headers are used in the request
      original_headers = HTTP.method(:headers)
      headers_argument = nil
      HTTP.stub(:headers, lambda { |headers|
        headers_argument = headers
        original_headers.call(headers)
      }) do
        request.perform
      end

      assert_equal(request.headers, headers_argument)
    end

    it "handles DELETE requests with params" do
      stub_delete("/1.1/test.json").with(query: {id: "123"}).to_return(
        body: '{"deleted": true}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :delete, "/1.1/test.json", {id: "123"})
      result = request.perform

      assert(result[:deleted])
    end

    describe "with json_post request" do
      it "sends JSON body" do
        stub_post("/1.1/test.json").to_return(
          body: '{"success": true}',
          headers: json_headers
        )
        request = Twitter::REST::Request.new(@client, :json_post, "/1.1/test.json", {data: "value"})
        result = request.perform

        assert(result[:success])
      end

      it "uses :json as the options key for json_post" do
        stub_post("/1.1/test.json").to_return(
          body: '{"received": true}',
          headers: json_headers
        )
        request = Twitter::REST::Request.new(@client, :json_post, "/1.1/test.json", {data: "value"})

        assert_equal({json: {data: "value"}}, request.send(:request_options))
        request.perform
      end
    end

    describe "with json_put request" do
      it "sends JSON body" do
        stub_put("/1.1/test.json").to_return(
          body: '{"success": true}',
          headers: json_headers
        )
        request = Twitter::REST::Request.new(@client, :json_put, "/1.1/test.json", {data: "value"})
        result = request.perform

        assert(result[:success])
      end

      it "uses :json as the options key for json_put" do
        stub_put("/1.1/test.json").to_return(
          body: '{"received": true}',
          headers: json_headers
        )
        request = Twitter::REST::Request.new(@client, :json_put, "/1.1/test.json", {data: "value"})

        assert_equal({json: {data: "value"}}, request.send(:request_options))
        request.perform
      end
    end

    describe "with params as separate argument" do
      it "sends both form data and query params" do
        stub_post("/1.1/test.json").with(query: {query_param: "qval"}).to_return(
          body: '{"success": true}',
          headers: json_headers
        )
        request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {form_data: "fval"}, {query_param: "qval"})
        result = request.perform

        assert(result[:success])
      end
    end
  end

  describe "error handling" do
    it "raises BadRequest for 400 status" do
      stub_get("/1.1/test.json").to_return(status: 400, body: '{"errors": [{"message": "Bad Request", "code": 1}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::BadRequest) { request.perform }
    end

    it "raises Unauthorized for 401 status" do
      stub_get("/1.1/test.json").to_return(status: 401, body: '{"errors": [{"message": "Unauthorized", "code": 32}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::Unauthorized) { request.perform }
    end

    it "raises Forbidden for 403 status" do
      stub_get("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Forbidden", "code": 1}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::Forbidden) { request.perform }
    end

    it "raises NotFound for 404 status" do
      stub_get("/1.1/test.json").to_return(status: 404, body: '{"errors": [{"message": "Not Found", "code": 34}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::NotFound) { request.perform }
    end

    it "raises TooManyRequests for 429 status" do
      stub_get("/1.1/test.json").to_return(status: 429, body: '{"errors": [{"message": "Rate limit exceeded", "code": 88}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::TooManyRequests) { request.perform }
    end

    it "raises InternalServerError for 500 status" do
      stub_get("/1.1/test.json").to_return(status: 500, body: '{"errors": [{"message": "Internal Error", "code": 131}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::InternalServerError) { request.perform }
    end

    it "raises BadGateway for 502 status" do
      stub_get("/1.1/test.json").to_return(status: 502, body: '{"errors": [{"message": "Bad Gateway"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::BadGateway) { request.perform }
    end

    it "raises ServiceUnavailable for 503 status" do
      stub_get("/1.1/test.json").to_return(status: 503, body: '{"errors": [{"message": "Service Unavailable"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::ServiceUnavailable) { request.perform }
    end

    it "raises GatewayTimeout for 504 status" do
      stub_get("/1.1/test.json").to_return(status: 504, body: '{"errors": [{"message": "Gateway Timeout"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::GatewayTimeout) { request.perform }
    end

    it "raises DuplicateStatus for duplicate status forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Status is a duplicate.", "code": 187}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      assert_raises(Twitter::Error::DuplicateStatus) { request.perform }
    end

    it "raises AlreadyFavorited for already favorited forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "You have already favorited this status.", "code": 139}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      assert_raises(Twitter::Error::AlreadyFavorited) { request.perform }
    end

    it "raises AlreadyRetweeted for already retweeted forbidden error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "You have already retweeted this Tweet.", "code": 327}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      assert_raises(Twitter::Error::AlreadyRetweeted) { request.perform }
    end

    it "raises AlreadyRetweeted for share validations failed error" do
      stub_post("/1.1/test.json").to_return(status: 403, body: '{"errors": [{"message": "Share validations failed", "code": 327}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      assert_raises(Twitter::Error::AlreadyRetweeted) { request.perform }
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
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::DuplicateStatus => e
        assert_kind_of(Twitter::RateLimit, e.rate_limit)
        assert_equal(15, e.rate_limit.limit)
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
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::Forbidden => e
        assert_kind_of(Twitter::RateLimit, e.rate_limit)
        assert_equal(20, e.rate_limit.limit)
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
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        assert_kind_of(Twitter::RateLimit, e.rate_limit)
        assert_equal(30, e.rate_limit.limit)
      end
    end

    it "passes body to error for non-forbidden errors" do
      stub_get("/1.1/test.json").to_return(
        status: 404,
        body: '{"errors": [{"message": "Resource not found", "code": 34}]}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::NotFound => e
        assert_equal("Resource not found", e.message)
        assert_equal(34, e.code)
      end
    end

    it "passes body to error for forbidden errors with specific message" do
      stub_post("/1.1/test.json").to_return(
        status: 403,
        body: '{"errors": [{"message": "Status is a duplicate.", "code": 187}]}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :post, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::DuplicateStatus => e
        assert_equal("Status is a duplicate.", e.message)
        assert_equal(187, e.code)
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
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      begin
        request.perform
      rescue Twitter::Error::InvalidMedia => e
        assert_equal("Invalid media format", e.message)
        assert_equal(25, e.rate_limit.limit)
      end
    end

    it "raises MediaError for processing info error" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "InvalidMedia", "message": "Invalid media", "code": 1}}}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::InvalidMedia) { request.perform }
    end

    it "raises MediaError for UnsupportedMedia" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "UnsupportedMedia", "message": "Unsupported media", "code": 2}}}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::UnsupportedMedia) { request.perform }
    end

    it "raises MediaInternalError for InternalError" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "InternalError", "message": "Internal error", "code": 3}}}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::MediaInternalError) { request.perform }
    end

    it "raises generic MediaError for unknown media error name" do
      stub_get("/1.1/test.json").to_return(
        status: 200,
        body: '{"processing_info": {"error": {"name": "UnknownError", "message": "Unknown error", "code": 99}}}',
        headers: json_headers
      )
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::MediaError) { request.perform }
    end

    it "does not raise error for 200 status" do
      stub_get("/1.1/test.json").to_return(status: 200, body: '{"success": true}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_nothing_raised { request.perform }
    end

    it "does not raise error for unknown status codes" do
      stub_get("/1.1/test.json").to_return(status: 201, body: '{"created": true}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_nothing_raised { request.perform }
    end

    it "raises NotAcceptable for 406 status" do
      stub_get("/1.1/test.json").to_return(status: 406, body: '{"errors": [{"message": "Not Acceptable"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::NotAcceptable) { request.perform }
    end

    it "raises RequestEntityTooLarge for 413 status" do
      stub_get("/1.1/test.json").to_return(status: 413, body: '{"errors": [{"message": "Request Entity Too Large"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::RequestEntityTooLarge) { request.perform }
    end

    it "raises UnprocessableEntity for 422 status" do
      stub_get("/1.1/test.json").to_return(status: 422, body: '{"errors": [{"message": "Unprocessable Entity"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::UnprocessableEntity) { request.perform }
    end

    it "raises TooManyRequests for 420 status" do
      stub_get("/1.1/test.json").to_return(status: 420, body: '{"errors": [{"message": "Rate limit exceeded"}]}', headers: json_headers)
      request = Twitter::REST::Request.new(@client, :get, "/1.1/test.json", {})
      assert_raises(Twitter::Error::TooManyRequests) { request.perform }
    end
  end

  describe "multipart uploads" do
    it "handles file uploads with GIF content type" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: json_headers)
      @client.update_with_media("Update", fixture_file("pbjt.gif"))

      assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
    end

    it "handles file uploads with JPEG content type" do
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: json_headers)
      @client.update_with_media("Update", fixture_file("me.jpeg"))

      assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
    end

    it "handles StringIO uploads with video/mp4 content type" do
      # Test content_type detection for StringIO files directly
      request = Twitter::REST::Request.new(@client, :multipart_post, "https://upload.twitter.com/1.1/media/upload.json", {}, {key: :media, file: StringIO.new("fake video data")})

      assert_equal(:post, request.request_method)
    end

    describe "file content type detection" do
      # Test content_type method directly using send
      it "returns image/gif for .gif files" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/gif", request.send(:content_type, "test.gif"))
      end

      it "returns image/gif for .GIF files (case insensitive)" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/gif", request.send(:content_type, "TEST.GIF"))
      end

      it "returns image/jpeg for .jpg files" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/jpeg", request.send(:content_type, "test.jpg"))
      end

      it "returns image/jpeg for .jpeg files" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/jpeg", request.send(:content_type, "test.jpeg"))
      end

      it "returns image/jpeg for .JPG files (case insensitive)" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/jpeg", request.send(:content_type, "TEST.JPG"))
      end

      it "returns image/jpeg for .JPEG files (case insensitive)" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/jpeg", request.send(:content_type, "TEST.JPEG"))
      end

      it "returns image/jpeg for .jpEg files (mixed case)" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/jpeg", request.send(:content_type, "test.jpEg"))
      end

      it "returns image/png for .png files" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/png", request.send(:content_type, "test.png"))
      end

      it "returns image/png for .PNG files (case insensitive)" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("image/png", request.send(:content_type, "TEST.PNG"))
      end

      it "returns application/octet-stream for unknown file types" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("application/octet-stream", request.send(:content_type, "test.bin"))
      end

      it "returns application/octet-stream for .mp4 files" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("application/octet-stream", request.send(:content_type, "test.mp4"))
      end

      it "returns application/octet-stream for files without extension" do
        request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

        assert_equal("application/octet-stream", request.send(:content_type, "testfile"))
      end
    end
  end
end
