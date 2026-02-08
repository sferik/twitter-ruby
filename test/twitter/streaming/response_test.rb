require "test_helper"

describe Twitter::Streaming::Response do
  let(:response_parser) { Twitter::Streaming::Response.new }

  describe "#initialize" do
    it "creates an LLHttp parser in response mode" do
      parser = Object.new

      captured_receiver = nil
      tokenizer = Object.new

      BufferedTokenizer.stub(:new, tokenizer) do
        LLHttp::Parser.stub(:new, lambda { |receiver, type:|
          captured_receiver = receiver

          assert_equal(:response, type)
          parser
        }) do
          response = Twitter::Streaming::Response.new

          assert_operator(response, :equal?, captured_receiver)
        end
      end
    end
  end

  describe "#on_headers_complete" do
    it "does not error if status code is 200" do
      assert_nothing_raised do
        response_parser << "HTTP/1.1 200 OK\r\nSome-Header: Woo\r\n\r\n"
      end
    end

    Twitter::Error::ERRORS.each do |code, klass|
      it "raises an exception of type #{klass} for status code #{code}" do
        assert_raises(klass) do
          response_parser << "HTTP/1.1 #{code} NOK\r\nSome-Header: Woo\r\n\r\n"
        end
      end
    end
  end

  describe "#on_body" do
    it "skips empty lines" do
      called = false
      response = Twitter::Streaming::Response.new { |_data| called = true }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("\r\n")

      refute(called)
    end

    it "parses JSON and calls the block with symbolized keys" do
      received = nil
      response = Twitter::Streaming::Response.new { |data| received = data }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("{\"foo\":\"bar\"}\r\n")

      assert_equal({foo: "bar"}, received)
    end

    it "continues past empty lines and parses later lines in the same chunk" do
      received = []
      response = Twitter::Streaming::Response.new { |data| received << data }
      response << "HTTP/1.1 200 OK\r\n\r\n"
      response.on_body("\r\n{\"foo\":\"bar\"}\r\n")

      assert_equal([{foo: "bar"}], received)
    end
  end

  describe "#on_status" do
    it "uses Twitter::Error::ERRORS even when Response::Error exists" do
      status_code, klass = Twitter::Error::ERRORS.first
      response = Twitter::Streaming::Response.new
      parser = Object.new
      parser.define_singleton_method(:status_code) { status_code }
      response.instance_variable_set(:@parser, parser)

      with_stubbed_const("Twitter::Streaming::Response::Error", Class.new.tap { |shadow| shadow.const_set(:ERRORS, {}.freeze) }) do
        assert_raises(klass) { response.on_status(status_code) }
      end
    end
  end
end
