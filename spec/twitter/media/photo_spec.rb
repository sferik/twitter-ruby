require 'helper'

describe Twitter::Media::Photo do
  it_behaves_like 'a Twitter::Media object'

  describe '#type' do
    it 'returns true when the type is set' do
      photo = Twitter::Media::Photo.new(id: 1, type: 'photo')
      expect(photo.type).to eq('photo')
    end
    it 'returns false when the type is not set' do
      photo = Twitter::Media::Photo.new(id: 1)
      expect(photo.type).to be_nil
    end
  end
end
