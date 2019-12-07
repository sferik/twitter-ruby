require 'helper'

describe Twitter::Entity::URI do
  describe '#display_uri' do
    it 'returns a String when the display_url is set' do
      uri = Twitter::Entity::URI.new(display_url: 'example.com/expanded...')
      expect(uri.display_uri).to be_a String
      expect(uri.display_uri).to eq('example.com/expanded...')
    end
    it 'returns nil when the display_url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.display_uri).to be_nil
    end
  end

  describe '#display_uri?' do
    it 'returns true when the display_url is set' do
      uri = Twitter::Entity::URI.new(display_url: 'example.com/expanded...')
      expect(uri.display_uri?).to be true
    end
    it 'returns false when the display_url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.display_uri?).to be false
    end
  end

  describe '#expanded_uri' do
    it 'returns a URI when the expanded_url is set' do
      uri = Twitter::Entity::URI.new(expanded_url: 'https://github.com/sferik')
      expect(uri.expanded_uri).to be_an Addressable::URI
      expect(uri.expanded_uri.to_s).to eq('https://github.com/sferik')
    end
    it 'returns nil when the expanded_url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.expanded_uri).to be_nil
    end
  end

  describe '#expanded_uri?' do
    it 'returns true when the expanded_url is set' do
      uri = Twitter::Entity::URI.new(expanded_url: 'https://github.com/sferik')
      expect(uri.expanded_uri?).to be true
    end
    it 'returns false when the expanded_url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.expanded_uri?).to be false
    end
  end

  describe '#uri' do
    it 'returns a URI when the url is set' do
      uri = Twitter::Entity::URI.new(url: 'https://github.com/sferik')
      expect(uri.uri).to be_an Addressable::URI
      expect(uri.uri.to_s).to eq('https://github.com/sferik')
    end
    it 'returns nil when the url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.uri).to be_nil
    end
  end

  describe '#uri?' do
    it 'returns true when the url is set' do
      uri = Twitter::Entity::URI.new(url: 'https://github.com/sferik')
      expect(uri.uri?).to be true
    end
    it 'returns false when the url is not set' do
      uri = Twitter::Entity::URI.new
      expect(uri.uri?).to be false
    end
  end
end
