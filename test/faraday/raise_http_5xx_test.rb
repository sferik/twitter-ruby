require 'test_helper'

class RaiseHttp5xxTest < Test::Unit::TestCase
  context "RaiseHttp5xx" do
    %w(json xml).each do |format|
      context "with request format #{format}" do

        setup do
          Twitter.format = format
          @client = Twitter::Client.new
        end

        should "raise InternalServerError when something is broken" do
          stub_get("statuses/show/500.#{format}", "internal_server_error.#{format}", :format => format, :status => 500)
          assert_raise Twitter::InternalServerError do
            @client.status(500)
          end
        end

        should "raise BadGateway when Twitter is down or being upgraded" do
          stub_get("statuses/show/502.#{format}", "bad_gateway.#{format}", :format => format, :status => 502)
          assert_raise Twitter::BadGateway do
            @client.status(502)
          end
        end

        should "raise ServiceUnavailable when Twitter servers are up, but overloaded with requests" do
          stub_get("statuses/show/503.#{format}", "service_unavailable.#{format}", :format => format, :status => 503)
          assert_raise Twitter::ServiceUnavailable do
            @client.status(503)
          end
        end
      end
    end
  end
end
