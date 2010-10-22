require 'test_helper'

class RaiseHttp4xxTest < Test::Unit::TestCase
  context "RaiseHttp4xx" do
    %w(json xml).each do |format|
      context "with request format #{format}" do
        setup do
          Twitter.format = format
          @client = Twitter::Client.new
        end

        should "raise BadRequest when rate limited" do
          stub_get("statuses/show/400.#{format}", "bad_request.#{format}", :format => format, :status => 400)
          assert_raise Twitter::BadRequest do
            @client.status(400)
          end
        end

        should "raise Unauthorized for a request to a protected user's timeline" do
          stub_get("statuses/user_timeline.#{format}?screen_name=protected", "unauthorized.#{format}", :format => format, :status => 401)
          assert_raise Twitter::Unauthorized do
            @client.user_timeline('protected')
          end
        end

        should "raise Forbidden when update limited" do
          stub_post("statuses/update.#{format}", "forbidden.#{format}", :format => format, :status => 403)
          assert_raise Twitter::Forbidden do
            @client.update('@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!')
          end
        end

        should "raise NotFound for a request to a deleted or nonexistent status" do
          stub_get("statuses/show/404.#{format}", "not_found.#{format}", :format => format, :status => 404)
          assert_raise Twitter::NotFound do
            @client.status(404)
          end
        end
      end
    end
  end
end
