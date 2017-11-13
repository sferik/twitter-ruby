require 'helper'

describe Twitter::REST::Request do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#request' do
    it 'encodes the entire body when no uploaded media is present' do
      stub_post('/1.1/statuses/update.json').with(body: {status: 'Update'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update('Update')
      expect(a_post('/1.1/statuses/update.json').with(body: {status: 'Update'})).to have_been_made
    end
    it 'encodes none of the body when uploaded media is present' do
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_post('/1.1/statuses/update.json').with(body: {status: 'Update', media_ids: '470030289822314497'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update_with_media('Update', fixture('pbjt.gif'))
      expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      expect(a_post('/1.1/statuses/update.json').with(body: {status: 'Update', media_ids: '470030289822314497'})).to have_been_made
    end

    context 'when using a proxy' do
      before do
        @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS', proxy: {host: '127.0.0.1', port: 3328})
      end
      it 'requests via the proxy when no uploaded media is present' do
        stub_post('/1.1/statuses/update.json').with(body: {status: 'Update'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
        expect(HTTP).to receive(:via).with('127.0.0.1', 3328).and_call_original
        @client.update('Update')
      end
      it 'requests via the proxy when uploaded media is present' do
        stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_post('/1.1/statuses/update.json').with(body: {status: 'Update', media_ids: '470030289822314497'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
        expect(HTTP).to receive(:via).with('127.0.0.1', 3328).twice.and_call_original
        @client.update_with_media('Update', fixture('pbjt.gif'))
      end

      context 'when using timeout options' do
        before do
          @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS', proxy: {host: '127.0.0.1', port: 3328}, timeouts: {connect: 2, read: 2, write: 3})
        end
        it 'requests with given timeout settings' do
          stub_post('/1.1/statuses/update.json').with(body: {status: 'Update'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
          expect_any_instance_of(HTTP::Client).to receive(:timeout).with(:per_operation, connect: 2, read: 2, write: 3).and_call_original
          @client.update('Update')
        end
      end
    end

    context 'when using timeout options' do
      before do
        @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS', timeouts: {connect: 2, read: 2, write: 3})
      end
      it 'requests with given timeout settings' do
        stub_post('/1.1/statuses/update.json').with(body: {status: 'Update'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
        expect(HTTP).to receive(:timeout).with(:per_operation, connect: 2, read: 2, write: 3).and_call_original
        @client.update('Update')
      end
    end
  end
end
