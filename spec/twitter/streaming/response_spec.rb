require "helper"

describe X::Streaming::Response do
  subject { described_class.new }

  describe "#on_headers_complete" do
    it "does not error if status code is 200" do
      expect do
        subject << "HTTP/1.1 200 OK\r\nSome-Header: Woo\r\n\r\n"
      end.not_to raise_error
    end

    X::Error::ERRORS.each do |code, klass|
      it "raises an exception of type #{klass} for status code #{code}" do
        expect do
          subject << "HTTP/1.1 #{code} NOK\r\nSome-Header: Woo\r\n\r\n"
        end.to raise_error(klass)
      end
    end
  end
end
