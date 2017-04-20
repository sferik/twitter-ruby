require 'helper'

describe Twitter::Media::Video do
  it_behaves_like 'a Twitter::Media object'

  describe '#video_info' do
    it 'returns a Twitter::Media::VideoInfo when the video is set' do
      video = Twitter::Media::Video.new(id: 1, video_info: {})
      expect(video.video_info).to be_a Twitter::Media::VideoInfo
    end
    it 'returns nil when the display_url is not set' do
      video = Twitter::Media::Video.new(id: 1, video_info: nil)
      expect(video.video_info).to be_nil
    end
  end
  describe '#type' do
    it 'returns true when the type is set' do
      video = Twitter::Media::Video.new(id: 1, type: 'video')
      expect(video.type).to eq('video')
    end
    it 'returns false when the type is not set' do
      video = Twitter::Media::Video.new(id: 1)
      expect(video.type).to be_nil
    end
  end
end
