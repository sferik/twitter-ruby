require 'helper'

describe Twitter::Streaming::Response do
  subject { Twitter::Streaming::Response.new }

  describe '#on_headers_complete' do
    it 'should not error if status code is 200' do
      expect do
        subject << "HTTP/1.1 200 OK\r\nSome-Header: Woo\r\n\r\n"
      end.to_not raise_error
    end

    Twitter::Error::ERRORS.each do |code, klass|
      it "should raise an exception of type #{klass} for status code #{code}" do
        expect do
          subject << "HTTP/1.1 #{code} NOK\r\nSome-Header: Woo\r\n\r\n"
        end.to raise_error(klass)
      end
    end
  end
end
