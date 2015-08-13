require 'helper'

describe Twitter::TargetUser do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      saved_search = Twitter::TargetUser.new(id: 1, name: 'foo')
      other = Twitter::TargetUser.new(id: 1, name: 'bar')
      expect(saved_search == other).to be true
    end
    it 'returns false when objects IDs are different' do
      saved_search = Twitter::TargetUser.new(id: 1)
      other = Twitter::TargetUser.new(id: 2)
      expect(saved_search == other).to be false
    end
    it 'returns false when classes are different' do
      saved_search = Twitter::TargetUser.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(saved_search == other).to be false
    end
  end
end
