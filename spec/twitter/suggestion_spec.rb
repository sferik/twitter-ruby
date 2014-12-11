require 'helper'

describe Twitter::Suggestion do
  describe '#==' do
    it 'returns true for empty objects' do
      suggestion = Twitter::Suggestion.new
      other = Twitter::Suggestion.new
      expect(suggestion == other).to be true
    end
    it 'returns true when objects slugs are the same' do
      suggestion = Twitter::Suggestion.new(slug: 1, name: 'foo')
      other = Twitter::Suggestion.new(slug: 1, name: 'bar')
      expect(suggestion == other).to be true
    end
    it 'returns false when objects slugs are different' do
      suggestion = Twitter::Suggestion.new(slug: 1)
      other = Twitter::Suggestion.new(slug: 2)
      expect(suggestion == other).to be false
    end
    it 'returns false when classes are different' do
      suggestion = Twitter::Suggestion.new(slug: 1)
      other = Twitter::Base.new(slug: 1)
      expect(suggestion == other).to be false
    end
  end

  describe '#users' do
    it 'returns a User when user is set' do
      users = Twitter::Suggestion.new(users: [{id: 7_505_382}]).users
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
    end
    it 'is empty when not set' do
      users = Twitter::Suggestion.new.users
      expect(users).to be_empty
    end
  end
end
