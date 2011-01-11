require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response do
  before do
    @client = Twitter::Client.new
  end

  {
    400 => Twitter::BadRequest,
    401 => Twitter::Unauthorized,
    403 => Twitter::Forbidden,
    404 => Twitter::NotFound,
    406 => Twitter::NotAcceptable,
    420 => Twitter::EnhanceYourCalm,
    500 => Twitter::InternalServerError,
    502 => Twitter::BadGateway,
    503 => Twitter::ServiceUnavailable,
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before do
        stub_get('statuses/user_timeline.json').
          with(:query => {:screen_name => 'sferik'}).
          to_return(:status => status)
      end

      it "should raise #{exception.name} error" do
        lambda do
          @client.user_timeline('sferik')
        end.should raise_error(exception)
      end
    end
  end
end
