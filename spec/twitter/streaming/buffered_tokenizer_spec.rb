require 'helper'

describe Twitter::Streaming::BufferedTokenizer do
  let(:tokenizer) { described_class.new("\r\n") }

  describe '#extract' do
    it 'returns an empty array when no delimiter is given' do
      expect(tokenizer.extract("foo bar")).to be_empty
    end

    it 'returns a token' do
      expect(tokenizer.extract("foo\r\n")).to eq ["foo"]
    end

    it 'returns multiple tokens' do
      expect(tokenizer.extract("foo")).to be_empty
      expect(tokenizer.extract("bar\r\nbaz\r\n")).to eq ["foobar", "baz"]
    end

    it 'handles splitted delimiter' do
      expect(tokenizer.extract("foo\r")).to be_empty
      expect(tokenizer.extract("\n")).to eq ["foo"]
    end
  end
end
