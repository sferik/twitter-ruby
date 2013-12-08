require 'helper'

describe Twitter::Token do

  describe '#bearer?' do
    it 'returns true when token is a bearer token' do
      token = Twitter::Token.new(:token_type => 'bearer')
      expect(token.bearer?).to be true
    end
    it 'returns false when token type is nil' do
      token = Twitter::Token.new
      expect(token.bearer?).to be false
    end
  end

end
