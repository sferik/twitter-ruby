shared_examples_for 'a Twitter::Media object' do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      media = described_class.new(id: 1)
      other = described_class.new(id: 1)
      expect(media == other).to be true
    end
    it 'returns false when objects IDs are different' do
      media = described_class.new(id: 1)
      other = described_class.new(id: 2)
      expect(media == other).to be false
    end
    it 'returns false when classes are different' do
      media = described_class.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(media == other).to be false
    end
  end

  describe '#sizes' do
    it 'returns a hash of Sizes when sizes is set' do
      sizes = described_class.new(id: 110_102_452_988_157_952, sizes: {small: {h: 226, w: 340, resize: 'fit'}, large: {h: 466, w: 700, resize: 'fit'}, medium: {h: 399, w: 600, resize: 'fit'}, thumb: {h: 150, w: 150, resize: 'crop'}}).sizes
      expect(sizes).to be_a Hash
      expect(sizes[:small]).to be_a Twitter::Size
    end
    it 'is empty when sizes is not set' do
      sizes = described_class.new(id: 110_102_452_988_157_952).sizes
      expect(sizes).to be_empty
    end
  end

  describe '#display_uri' do
    it 'returns a String when the display_url is set' do
      photo = Twitter::Media::Photo.new(id: 1, display_url: 'example.com/expanded...')
      expect(photo.display_uri).to be_a String
      expect(photo.display_uri).to eq('example.com/expanded...')
    end
    it 'returns nil when the display_url is not set' do
      photo = Twitter::Media::Photo.new(id: 1)
      expect(photo.display_uri).to be_nil
    end
  end

  describe '#display_uri?' do
    it 'returns true when the display_url is set' do
      photo = Twitter::Media::Photo.new(id: 1, display_url: 'example.com/expanded...')
      expect(photo.display_uri?).to be true
    end
    it 'returns false when the display_url is not set' do
      photo = Twitter::Media::Photo.new(id: 1)
      expect(photo.display_uri?).to be false
    end
  end

  describe '#expanded_uri' do
    it 'returns a URI when the expanded_url is set' do
      media = described_class.new(id: 1, expanded_url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.expanded_uri).to be_an Addressable::URI
      expect(media.expanded_uri.to_s).to eq('http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
    end
    it 'returns nil when the expanded_url is not set' do
      media = described_class.new(id: 1)
      expect(media.expanded_uri).to be_nil
    end
  end

  describe '#expanded_uri?' do
    it 'returns true when the expanded_url is set' do
      media = described_class.new(id: 1, expanded_url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.expanded_uri?).to be true
    end
    it 'returns false when the expanded_url is not set' do
      media = described_class.new(id: 1)
      expect(media.expanded_uri?).to be false
    end
  end

  describe '#media_uri' do
    it 'returns a URI when the media_url is set' do
      media = described_class.new(id: 1, media_url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.media_uri).to be_an Addressable::URI
      expect(media.media_uri.to_s).to eq('http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
    end
    it 'returns nil when the media_url is not set' do
      media = described_class.new(id: 1)
      expect(media.media_uri).to be_nil
    end
  end

  describe '#media_uri?' do
    it 'returns true when the media_url is set' do
      media = described_class.new(id: 1, media_url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.media_uri?).to be true
    end
    it 'returns false when the media_url is not set' do
      media = described_class.new(id: 1)
      expect(media.media_uri?).to be false
    end
  end

  describe '#media_uri_https' do
    it 'returns a URI when the media_url_https is set' do
      media = described_class.new(id: 1, media_url_https: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.media_uri_https).to be_an Addressable::URI
      expect(media.media_uri_https.to_s).to eq('http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
    end
    it 'returns nil when the media_url_https is not set' do
      media = described_class.new(id: 1)
      expect(media.media_uri_https).to be_nil
    end
  end

  describe '#media_uri_https?' do
    it 'returns true when the media_url_https is set' do
      media = described_class.new(id: 1, media_url_https: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.media_uri_https?).to be true
    end
    it 'returns false when the media_url_https is not set' do
      media = described_class.new(id: 1)
      expect(media.media_uri_https?).to be false
    end
  end

  describe '#uri' do
    it 'returns a URI when the url is set' do
      media = described_class.new(id: 1, url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.uri).to be_an Addressable::URI
      expect(media.uri.to_s).to eq('http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
    end
    it 'returns nil when the url is not set' do
      media = described_class.new(id: 1)
      expect(media.uri).to be_nil
    end
  end

  describe '#uri?' do
    it 'returns true when the url is set' do
      media = described_class.new(id: 1, url: 'http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png')
      expect(media.uri?).to be true
    end
    it 'returns false when the url is not set' do
      media = described_class.new(id: 1)
      expect(media.uri?).to be false
    end
  end
end
