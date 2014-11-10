require 'helper'

describe Twitter::SavedSearch do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      saved_search = Twitter::SavedSearch.new(id: 1, name: 'foo')
      other = Twitter::SavedSearch.new(id: 1, name: 'bar')
      expect(saved_search == other).to be true
    end
    it 'returns false when objects IDs are different' do
      saved_search = Twitter::SavedSearch.new(id: 1)
      other = Twitter::SavedSearch.new(id: 2)
      expect(saved_search == other).to be false
    end
    it 'returns false when classes are different' do
      saved_search = Twitter::SavedSearch.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(saved_search == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created_at is set' do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(saved_search.created_at).to be_a Time
      expect(saved_search.created_at).to be_utc
    end
    it 'returns nil when created_at is not set' do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012)
      expect(saved_search.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(saved_search.created?).to be true
    end
    it 'returns false when created_at is not set' do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012)
      expect(saved_search.created?).to be false
    end
  end
end
