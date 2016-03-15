require 'helper'

describe Twitter::Media::AnimatedGif do
  it_behaves_like 'a Twitter::Media object'

  describe '#video_info' do
    it 'returns a Twitter::Media::VideoInfo when the video is set' do
      image = Twitter::Media::AnimatedGif.new(id: 1, video_info: {})
      expect(image.video_info).to be_a Twitter::Media::VideoInfo
    end
    it 'returns nil when the display_url is not set' do
      image = Twitter::Media::AnimatedGif.new(id: 1, video_info: nil)
      expect(image.video_info).to be_nil
    end
  end
end
