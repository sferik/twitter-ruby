require 'helper'

describe Twitter::List do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      list = Twitter::List.new(id: 1, slug: 'foo')
      other = Twitter::List.new(id: 1, slug: 'bar')
      expect(list == other).to be true
    end
    it 'returns false when objects IDs are different' do
      list = Twitter::List.new(id: 1)
      other = Twitter::List.new(id: 2)
      expect(list == other).to be false
    end
    it 'returns false when classes are different' do
      list = Twitter::List.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(list == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created_at is set' do
      list = Twitter::List.new(id: 8_863_586, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(list.created_at).to be_a Time
      expect(list.created_at).to be_utc
    end
    it 'returns nil when created_at is not set' do
      list = Twitter::List.new(id: 8_863_586)
      expect(list.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      list = Twitter::List.new(id: 8_863_586, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(list.created?).to be true
    end
    it 'returns false when created_at is not set' do
      list = Twitter::List.new(id: 8_863_586)
      expect(list.created?).to be false
    end
  end

  describe '#members_uri' do
    it 'returns the URI to the list members' do
      list = Twitter::List.new(id: 8_863_586, slug: 'presidents', user: {id: 7_505_382, screen_name: 'sferik'})
      expect(list.members_uri.to_s).to eq('https://twitter.com/sferik/presidents/members')
    end
  end

  describe '#subscribers_uri' do
    it 'returns the URI to the list subscribers' do
      list = Twitter::List.new(id: 8_863_586, slug: 'presidents', user: {id: 7_505_382, screen_name: 'sferik'})
      expect(list.subscribers_uri.to_s).to eq('https://twitter.com/sferik/presidents/subscribers')
    end
  end

  describe '#uri' do
    it 'returns the URI to the list' do
      list = Twitter::List.new(id: 8_863_586, slug: 'presidents', user: {id: 7_505_382, screen_name: 'sferik'})
      expect(list.uri.to_s).to eq('https://twitter.com/sferik/presidents')
    end
  end

  describe '#user' do
    it 'returns a User when user is set' do
      list = Twitter::List.new(id: 8_863_586, user: {id: 7_505_382})
      expect(list.user).to be_a Twitter::User
    end
    it 'returns nil when status is not set' do
      list = Twitter::List.new(id: 8_863_586)
      expect(list.user).to be_nil
    end
  end

  describe '#user?' do
    it 'returns true when user is set' do
      list = Twitter::List.new(id: 8_863_586, user: {id: 7_505_382})
      expect(list.user?).to be true
    end
    it 'returns false when user is not set' do
      list = Twitter::List.new(id: 8_863_586)
      expect(list.user?).to be false
    end
  end
end
