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
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_post('/1.1/statuses/update.json').with(body: {status: 'Update', media_ids: '470030289822314497'}).to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update_with_media('Update', fixture('pbjt.gif'))
      expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      expect(a_post('/1.1/statuses/update.json').with(body: {status: 'Update', media_ids: '470030289822314497'})).to have_been_made
    end
  end
end
