require 'helper'

describe Twitter::REST::FormEncoder do
  describe '.encode' do
    it 'encodes asterisk correctly' do
      expect(described_class.encode({status: 'Update *'})).to eq('status=Update%20%2A')
    end
  end
end
