require "helper"

describe Twitter::Streaming::Response do
  subject { described_class.new }

  describe "#initialize" do
    it "creates an LLHttp parser in response mode" do
      parser = double("parser")
      allow(BufferedTokenizer).to receive(:new).and_return(double("tokenizer"))

      captured_receiver = nil
      expect(LLHttp::Parser).to receive(:new) do |receiver, type:|
        captured_receiver = receiver
        expect(type).to eq(:response)
        parser
      end

      response = described_class.new
      expect(captured_receiver).to be(response)
    end
  end

  describe "#on_headers_complete" do
    it "does not error if status code is 200" do
      expect do
        subject << "HTTP/1.1 200 OK\r\nSome-Header: Woo\r\n\r\n"
      end.not_to raise_error
    end

    Twitter::Error::ERRORS.each do |code, klass|
      it "raises an exception of type #{klass} for status code #{code}" do
        expect do
          subject << "HTTP/1.1 #{code} NOK\r\nSome-Header: Woo\r\n\r\n"
        end.to raise_error(klass)
      end
    end
  end

  describe "#on_body" do
    it "skips empty lines" do
      called = false
      response = described_class.new { |_data| called = true }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("\r\n")
      expect(called).to be false
    end

    it "parses JSON and calls the block with symbolized keys" do
      received = nil
      response = described_class.new { |data| received = data }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("{\"foo\":\"bar\"}\r\n")
      expect(received).to eq({foo: "bar"})
    end

    it "continues past empty lines and parses later lines in the same chunk" do
      received = []
      response = described_class.new { |data| received << data }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("\r\n{\"foo\":\"bar\"}\r\n")

      expect(received).to eq([{foo: "bar"}])
    end
  end

  describe "#on_status" do
    it "uses Twitter::Error::ERRORS even when Response::Error exists" do
      status_code, klass = Twitter::Error::ERRORS.first
      response = described_class.new
      response.instance_variable_set(:@parser, double("parser", status_code: status_code))
      stub_const("Twitter::Streaming::Response::Error", Class.new do
        ERRORS = {}
      end)

      expect { response.on_status(status_code) }.to raise_error(klass)
    end
  end
end
