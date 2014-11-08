require 'helper'

describe Twitter::Base do
  before do
    @base = Twitter::Base.new(id: 1)
  end

  describe '#[]' do
    it 'calls methods using [] with symbol' do
      capture_warning do
        expect(@base[:object_id]).to be_an Integer
      end
    end
    it 'calls methods using [] with string' do
      capture_warning do
        expect(@base['object_id']).to be_an Integer
      end
    end
    it 'returns nil for missing method' do
      capture_warning do
        expect(@base[:foo]).to be_nil
        expect(@base['foo']).to be_nil
      end
    end
  end

  describe '#attrs' do
    it 'returns a hash of attributes' do
      expect(@base.attrs).to eq(id: 1)
    end
  end
end
