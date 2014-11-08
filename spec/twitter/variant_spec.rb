require 'helper'

describe Twitter::Variant do
  describe '#uri' do
    it 'returns a URI when the url is set' do
      variant = Twitter::Variant.new(id: 1, url: 'https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4')
      expect(variant.uri).to be_an Addressable::URI
      expect(variant.uri.to_s).to eq('https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4')
    end
    it 'returns nil when the url is not set' do
      variant = Twitter::Variant.new({})
      expect(variant.uri).to be_nil
    end
  end

  describe '#uri?' do
    it 'returns true when the url is set' do
      variant = Twitter::Variant.new(id: 1, url: 'https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4')
      expect(variant.uri?).to be true
    end
    it 'returns false when the url is not set' do
      variant = Twitter::Variant.new({})
      expect(variant.uri?).to be false
    end
  end
end
