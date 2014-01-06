require 'helper'

describe Twitter::NullObject do

  describe '#nil?' do
    it 'returns true' do
      expect(subject.nil?).to be true
    end
  end

  describe '#to_a' do
    it 'returns an empty array' do
      expect(subject.to_a).to be_an Array
      expect(subject.to_a).to be_empty
    end
  end

  describe '#to_ary' do
    it 'returns an empty array' do
      expect(subject.to_ary).to be_an Array
      expect(subject.to_ary).to be_empty
    end
  end

  if RUBY_VERSION >= '1.9'
    describe '#to_c' do
      it 'returns zero as a complex number' do
        expect(subject.to_c).to be_a Complex
        expect(subject.to_c).to be_zero
      end
    end

    describe '#to_r' do
      it 'returns zero as a rational number' do
        expect(subject.to_r).to be_a Rational
        expect(subject.to_r).to be_zero
      end
    end
  end

  if RUBY_VERSION >= '2.0'
    describe '#to_h' do
      it 'returns an empty hash' do
        expect(subject.to_h).to be_a Hash
        expect(subject.to_h).to be_empty
      end
    end
  end

  describe '#to_f' do
    it 'returns zero as a floating point number' do
      expect(subject.to_f).to be_a Float
      expect(subject.to_f).to be_zero
    end
  end

  describe '#to_i' do
    it 'returns zero' do
      expect(subject.to_i).to be_an Integer
      expect(subject.to_i).to be_zero
    end
  end

  describe '#to_s' do
    it 'returns an empty string' do
      expect(subject.to_s).to be_a String
      expect(subject.to_s).to be_empty
    end
  end

  describe '#to_str' do
    it 'returns an empty string' do
      expect(subject.to_str).to be_a String
      expect(subject.to_str).to be_empty
    end
  end

  describe 'calling any method' do
    it 'returns self' do
      expect(subject.any).to equal subject
    end
  end

  describe '#respond_to?' do
    it 'returns true' do
      expect(subject.respond_to?(:any)).to be true
    end
  end

end
