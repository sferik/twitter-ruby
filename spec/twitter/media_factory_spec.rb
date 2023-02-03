require 'helper'

describe Twitter::MediaFactory do
  describe '.new' do
    it 'generates a photo' do
      media = described_class.new(id: 1, type: 'photo')
      expect(media).to be_a Twitter::Media::Photo
    end

    it 'generates an animated GIF' do
      media = described_class.new(id: 1, type: 'animated_gif')
      expect(media).to be_a Twitter::Media::AnimatedGif
    end

    it 'generates a video' do
      media = described_class.new(id: 1, type: 'video')
      expect(media).to be_a Twitter::Media::Video
    end

    it 'raises an IndexError when type is not specified' do
      expect { described_class.new }.to raise_error(IndexError)
    end
  end
end
