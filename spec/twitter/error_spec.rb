require 'helper'

describe Twitter::Error do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#code' do
    it 'returns the error code' do
      error = Twitter::Error.new('execution expired', {}, 123)
      expect(error.code).to eq(123)
    end
  end

  describe '#message' do
    it 'returns the error message' do
      error = Twitter::Error.new('execution expired')
      expect(error.message).to eq('execution expired')
    end
  end

  describe '#rate_limit' do
    it 'returns a rate limit object' do
      error = Twitter::Error.new('execution expired')
      expect(error.rate_limit).to be_a Twitter::RateLimit
    end
  end

  %w[error errors].each do |key|
    context "when JSON body contains #{key}" do
      before do
        body = "{\"#{key}\":\"Internal Server Error\"}"
        stub_get('/1.1/statuses/user_timeline.json').with(query: {screen_name: 'sferik'}).to_return(status: 500, body: body, headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'raises an exception with the proper message' do
        expect { @client.user_timeline('sferik') }.to raise_error(Twitter::Error::InternalServerError)
      end
    end
  end

  Twitter::Error::ERRORS.each do |status, exception|
    context "when HTTP status is #{status}" do
      before do
        stub_get('/1.1/statuses/user_timeline.json').with(query: {screen_name: 'sferik'}).to_return(status: status, body: '{}', headers: {content_type: 'application/json; charset=utf-8'})
      end
      it "raises #{exception}" do
        expect { @client.user_timeline('sferik') }.to raise_error(exception)
      end
    end
  end
end
