# coding: utf-8
require 'helper'

describe Twitter::REST::Media do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#upload_media_simple' do
    before do
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'uploads the file' do
      @client.upload_media_simple(fixture('pbjt.gif'))
      expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
    end

    it 'returns the media id' do
      media_id = @client.upload_media_simple(fixture('pbjt.gif'))

      expect(media_id.to_s).to eq '470030289822314497'
    end

    it 'accepts a media_category parameter' do
      expect(Twitter::REST::Request).to receive(:new)
        .with(any_args, hash_including(media_category: 'test'))
        .and_return(double(perform: {media_id: 123}))

      @client.upload_media_simple(fixture('pbjt.gif'), media_category: 'test')
    end
  end

  describe '#upload_media_chunked' do
    context 'synchronous upload' do
      before do
        stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'uploads the file in chunks' do
        @client.upload_media_chunked(fixture('1080p.mp4'))

        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made.times(3)
      end

      it 'returns the media id' do
        media_id = @client.upload_media_chunked(fixture('1080p.mp4'))

        expect(media_id.to_s).to eq '470030289822314497'
      end
    end

    it 'polls the status until processing is complete' do
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return do |request|
        {
          headers: {content_type: 'application/json; charset=utf-8'},
          body: case request.body
                when /command=(INIT|APPEND)/
                  fixture('upload.json')
                when /command=FINALIZE/
                  '{"processing_info": {"state": "pending", "check_after_secs": 5}}'
                end,
        }
      end
      stub_request(:get, 'https://upload.twitter.com/1.1/media/upload.json')
        .with(query: {command: 'STATUS', media_id: '470030289822314497'})
        .to_return(
          headers: {content_type: 'application/json; charset=utf-8'},
          body: '{"processing_info": {"state": "succeeded"}}'
        )

      expect(@client).to receive(:sleep).with(5)

      @client.upload_media_chunked(fixture('1080p.mp4'), media_category: 'tweet_video')

      expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made.times(3)
    end
  end
end
