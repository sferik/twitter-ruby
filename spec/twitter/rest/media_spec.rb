# coding: utf-8
require 'helper'

describe Twitter::REST::Tweets do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#upload_media' do
    before do
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    context 'with a gif image' do
      it 'requests the correct resource' do
        @client.upload_media(fixture('pbjt.gif'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'with a jpe image' do
      it 'requests the correct resource' do
        @client.upload_media(fixture('wildcomet2.jpe'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'with a jpeg image' do
      it 'requests the correct resource' do
        @client.upload_media(fixture('me.jpeg'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'with a png image' do
      it 'requests the correct resource' do
        @client.upload_media(fixture('we_concept_bg2.png'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'with a mp4 video' do
      it 'requests the correct resources' do
        @client.upload_media(fixture('1080p.mp4'))
        # INIT, APPEND, FINIALIZE
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made.times(3)
      end
    end
    context 'with a Tempfile' do
      it 'requests the correct resource' do
        @client.upload_media(Tempfile.new('tmp'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
  end
end
