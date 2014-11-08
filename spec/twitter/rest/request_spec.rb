require 'helper'

describe Twitter::REST::Request do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
    @request = Twitter::REST::Request.new(@client, :get, '/path')
  end

  describe '#request' do
    it 'encodes the entire body when no uploaded media is present' do
      stub_post('/1.1/statuses/update.json').with(body: {status: 'Update'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update('Update')
      expect(a_post('/1.1/statuses/update.json').with(body: {status: 'Update'})).to have_been_made
    end
    it 'encodes none of the body when uploaded media is present' do
      stub_post('/1.1/statuses/update_with_media.json').to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update_with_media('Update', fixture('pbjt.gif'))
      expect(a_post('/1.1/statuses/update_with_media.json')).to have_been_made
    end
    it 'catches and reraises Faraday timeout errors' do
      allow(@client).to receive(:connection).and_raise(Faraday::Error::TimeoutError.new('execution expired'))
      expect { @request.perform }.to raise_error(Twitter::Error::RequestTimeout)
    end
    it 'catches and reraises Timeout errors' do
      allow(@client).to receive(:connection).and_raise(Timeout::Error.new('execution expired'))
      expect { @request.perform }.to raise_error(Twitter::Error::RequestTimeout)
    end
    it 'catches and reraises Faraday client errors' do
      allow(@client).to receive(:connection).and_raise(Faraday::Error::ClientError.new('connection failed'))
      expect { @request.perform }.to raise_error(Twitter::Error)
    end
    it 'catches and reraises JSON::ParserError errors' do
      allow(@client).to receive(:connection).and_raise(JSON::ParserError.new('unexpected token'))
      expect { @request.perform }.to raise_error(Twitter::Error)
    end
  end
end
