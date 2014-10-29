require 'helper'

describe Twitter::NullObject do

  describe '#instance_of?' do
    it 'returns true for Twitter::NullObject' do
      expect(subject.instance_of?(Twitter::NullObject)).to be true
    end
    it 'returns false for other classes' do
      expect(subject.instance_of?(String)).to be false
    end
  end

  describe '#kind_of?' do
    it 'returns true for Twitter::NullObject' do
      expect(subject).to be_a Twitter::NullObject
    end
    it 'returns true for module ancestors' do
      expect(subject).to be_a Comparable
    end
    it 'returns true for class ancestors' do
      expect(subject).to be_a Naught::BasicObject
    end
    it 'returns false for non-ancestors' do
      expect(subject).not_to be_a String
    end
  end

  describe '#<=>' do
    it 'sorts before non-null objects' do
      expect(subject <=> 1).to eq(-1)
    end
    it 'is equal to other Twitter::NullObjects' do
      null_object1 = Twitter::NullObject.new
      null_object2 = Twitter::NullObject.new
      expect(null_object1 <=> null_object2).to eq(0)
    end
  end

  describe '#nil?' do
    it 'returns true' do
      expect(subject).to be_nil
    end
  end

  describe 'black hole' do
    it 'returns self for missing methods' do
      expect(subject.missing).to eq(subject)
    end
  end

  describe 'explicit conversions' do
    describe '#to_a' do
      it 'returns []' do
        expect(subject.to_a).to eq([])
      end
    end
    describe '#to_s' do
      it 'returns ""' do
        expect(subject.to_s).to eq("")
      end
    end
  end

  describe 'implicit conversions' do
    describe '#to_ary' do
      it 'returns []' do
        expect(subject.to_ary).to eq([])
      end
    end
    describe '#to_str' do
      it 'returns ""' do
        expect(subject.to_str).to eq("")
      end
    end
  end

  describe 'predicates' do
    it 'return false for missing methods' do
      expect(subject.missing?).to be false
    end
  end

  describe 'predicates' do
    it 'return false for missing methods' do
      expect(subject.missing?).to be false
    end
  end

end
