require 'test_helper'

class RaiseErrorsTest < Test::Unit::TestCase

  context "RaiseErrors" do
    setup do
      @client = Twitter::Base.new
      @search = Twitter::Search.new
    end

    should "raise BadRequest when rate limited" do
      stub_get('/1/statuses/show/1.json', 'bad_request.json', 400)
      assert_raise Twitter::BadRequest do
        Twitter.status(1)
      end
    end

    should "raise Unauthorized for a request to a protected user's timeline" do
      stub_get('/1/statuses/user_timeline.json?screen_name=protected', 'unauthorized.json', 401)
      assert_raise Twitter::Unauthorized do
        Twitter.timeline('protected')
      end
    end

    should "raise Forbidden when update limited" do
      stub_post('/1/statuses/update.json', 'forbidden.json', 403)
      assert_raise Twitter::Forbidden do
        @client.update('@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!')
      end
    end

    should "raise NotFound for a request to a deleted or nonexistent status" do
      stub_get('/1/statuses/show/1.json', 'not_found.json', 404)
      assert_raise Twitter::NotFound do
        Twitter.status(1)
      end
    end

    should "raise NotAcceptable when an invalid format is specified" do
      stub_get('https://search.twitter.com/search.json?q=from%3Asferik', 'not_acceptable.json', 406)
      assert_raise Twitter::NotAcceptable do
        @search.from('sferik')
        @search.fetch
      end
    end

    should "raise EnhanceYourCalm when search is rate limited" do
      stub_get('https://search.twitter.com/search.json?q=from%3Asferik', 'enhance_your_calm.json', 420)
      assert_raise Twitter::EnhanceYourCalm do
        @search.from('sferik')
        @search.fetch
      end
    end

    should "raise InternalServerError when something is broken" do
      stub_get('/1/statuses/show/1.json', 'internal_server_error.json', 500)
      assert_raise Twitter::InternalServerError do
        Twitter.status(1)
      end
    end

    should "raise BadGateway when Twitter is down or being upgraded" do
      stub_get('/1/statuses/show/1.json', 'bad_gateway.json', 502)
      assert_raise Twitter::BadGateway do
        Twitter.status(1)
      end
    end

    should "raise ServiceUnavailable when Twitter servers are up, but overloaded with requests" do
      stub_get('/1/statuses/show/1.json', 'service_unavailable.json', 503)
      assert_raise Twitter::ServiceUnavailable do
        Twitter.status(1)
      end
    end

  end
end
