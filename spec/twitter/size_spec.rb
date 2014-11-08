require 'helper'

describe Twitter::Size do
  describe '#==' do
    it 'returns true for empty objects' do
      size = Twitter::Size.new
      other = Twitter::Size.new
      expect(size == other).to be true
    end
    it 'returns true when objects height and width are the same' do
      size = Twitter::Size.new(h: 1, w: 1, resize: true)
      other = Twitter::Size.new(h: 1, w: 1, resize: false)
      expect(size == other).to be true
    end
    it 'returns false when objects height or width are different' do
      size = Twitter::Size.new(h: 1, w: 1)
      other = Twitter::Size.new(h: 1, w: 2)
      expect(size == other).to be false
    end
    it 'returns false when classes are different' do
      size = Twitter::Size.new(h: 1, w: 1)
      other = Twitter::Base.new(h: 1, w: 1)
      expect(size == other).to be false
    end
  end
end
