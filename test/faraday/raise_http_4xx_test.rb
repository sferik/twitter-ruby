require 'test_helper'

class RaiseHttp4xxTest < Test::Unit::TestCase

  context "RaiseHttp4xx" do
    %w(json xml).each do |format|
      context "with request format #{format}" do

        setup do
          Twitter.format = format
        end

        should "raise BadRequest when rate limited" do
          stub_get("statuses/show/1.#{format}", "bad_request.#{format}", 400)
          assert_raise Twitter::BadRequest do
            Twitter.status(1)
          end
        end

        should "raise Unauthorized for a request to a protected user's timeline" do
          stub_get("statuses/user_timeline.#{format}?screen_name=protected", "unauthorized.#{format}", 401)
          assert_raise Twitter::Unauthorized do
            Twitter.timeline('protected')
          end
        end

        should "raise Forbidden when update limited" do
          stub_post("statuses/update.#{format}", "forbidden.#{format}", 403)
          assert_raise Twitter::Forbidden do
            client = Twitter::Authenticated.new
            client.update('@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!')
          end
        end

        should "raise NotFound for a request to a deleted or nonexistent status" do
          stub_get("statuses/show/1.#{format}", "not_found.#{format}", 404)
          assert_raise Twitter::NotFound do
            Twitter.status(1)
          end
        end
      end
    end

    should "raise NotAcceptable when an invalid format is specified" do
      stub_get("search.json?q=from%3Asferik", "not_acceptable.json", 406)
      assert_raise Twitter::NotAcceptable do
        search = Twitter::Search.new
        search.from('sferik')
        search.fetch
      end
    end

    should "raise EnhanceYourCalm when search is rate limited" do
      stub_get("search.json?q=from%3Asferik", "enhance_your_calm.text", 420, nil, true)
      begin
        search = Twitter::Search.new
        search.from('sferik')
        search.fetch
        flunk 'Should have exception at this point'
      rescue => err
        assert_instance_of Twitter::EnhanceYourCalm, err
        assert_operator err.waiting_time, :> , 0
      end
    end

  end
end
