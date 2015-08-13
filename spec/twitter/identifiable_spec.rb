require 'helper'

describe Twitter::Identity do
  describe '#initialize' do
    it 'raises an IndexError when id is not specified' do
      expect { Twitter::Identity.new }.to raise_error(IndexError)
    end
  end

  describe '#==' do
    it 'returns true when objects IDs are the same' do
      one = Twitter::Identity.new(id: 1, screen_name: 'sferik')
      two = Twitter::Identity.new(id: 1, screen_name: 'garybernhardt')
      expect(one == two).to be true
    end
    it 'returns false when objects IDs are different' do
      one = Twitter::Identity.new(id: 1)
      two = Twitter::Identity.new(id: 2)
      expect(one == two).to be false
    end
    it 'returns false when classes are different' do
      one = Twitter::Identity.new(id: 1)
      two = Twitter::Base.new(id: 1)
      expect(one == two).to be false
    end
  end
end
