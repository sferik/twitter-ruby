require 'helper'

describe Twitter::REST::Media do
  before do
    @client = Twitter::REST::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :access_token => 'AT', :access_token_secret => 'AS')
  end

  describe '#upload' do
    before do
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(:body => fixture('upload.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    context 'a gif image' do
      it 'requests the correct resource' do
        @client.upload(fixture('pbjt.gif'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
      it 'returns an Integer' do
        media_id = @client.upload(fixture('pbjt.gif'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
        expect(media_id).to be_an Integer
        expect(media_id).to eq(470_030_289_822_314_497)
      end
    end
    context 'a jpe image' do
      it 'requests the correct resource' do
        @client.upload(fixture('wildcomet2.jpe'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'a jpeg image' do
      it 'requests the correct resource' do
        @client.upload(fixture('me.jpeg'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'a png image' do
      it 'requests the correct resource' do
        @client.upload(fixture('we_concept_bg2.png'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'a Tempfile' do
      it 'requests the correct resource' do
        @client.upload(Tempfile.new('tmp'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      end
    end
    context 'A non IO object' do
      it 'raises an error' do
        expect { @client.upload('Unacceptable IO') }.to raise_error(Twitter::Error::UnacceptableIO)
      end
    end
  end
end
