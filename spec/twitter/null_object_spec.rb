require 'helper'

describe Twitter::NullObject do
  describe '#!' do
    it 'returns true' do
      expect(!subject).to be true
    end
  end

  describe '#respond_to?' do
    it 'returns true for any method' do
      expect(subject).to respond_to(:missing?)
    end
  end

  describe '#respond_to?' do
    it 'returns true for any method' do
      expect(subject).to respond_to(:missing?)
    end
  end

  describe '#instance_of?' do
    it 'returns true for Twitter::NullObject' do
      expect(subject).to be_instance_of(Twitter::NullObject)
    end
    it 'returns false for other classes' do
      expect(subject).not_to be_instance_of(String)
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
      expect(subject.nil?).to be true
    end
  end

  describe '#as_json' do
    it "returns 'null'" do
      expect(subject.as_json).to eq('null')
    end
  end

  describe '#to_json' do
    it 'returns JSON' do
      expect({'null_object' => subject}.to_json).to eq('{"null_object":null}')
    end
  end

  describe 'black hole' do
    it 'returns self for missing methods' do
      expect(subject.missing).to eq(subject)
    end
  end

  describe 'explicit conversions' do
    describe '#to_a' do
      it 'returns an empty array' do
        expect(subject.to_a).to be_empty
      end
    end
    describe '#to_s' do
      it 'returns an empty string' do
        expect(subject.to_s).to be_empty
      end
    end
  end

  describe 'implicit conversions' do
    describe '#to_ary' do
      it 'returns an empty array' do
        expect(subject.to_ary).to be_empty
      end
    end
    describe '#to_str' do
      it 'returns an empty string' do
        expect(subject.to_str).to be_empty
      end
    end
  end

  describe 'predicates' do
    it 'return false for missing methods' do
      expect(subject).not_to be_missing
    end
  end

  describe '#presence' do
    it 'returns nil' do
      expect(subject.presence).to eq nil
    end
  end

  describe '#blank?' do
    it 'returns true' do
      expect(subject.blank?).to eq true
    end
  end

  describe '#present?' do
    it 'returns false' do
      expect(subject.present?).to eq false
    end
  end
end
