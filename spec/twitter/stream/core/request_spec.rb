require 'helper'

describe Twitter::Stream::Request do
  let(:proxy_options) { { :uri => 'http://my-proxy:8080', :user => 'username', :password => 'password' } }
  let(:default_options) {
    { :path   => '/1.1/statuses/filter.json',
    :params => { :track => 'nfl' },
    :headers => {},
    :method => 'POST',
    :oauth => {}
    }
  }

  describe ".new" do
    it "assigns a proxy if one is set" do
      req = Twitter::Stream::Request.new(:proxy => proxy_options)
      expect(req.proxy).to be
    end

    it "overrides defaults" do
      req = Twitter::Stream::Request.new(default_options)
      expect(req.options[:path]).to eq('/1.1/statuses/filter.json')
    end
  end

  describe '#oauth_header' do
    it 'passes params on POST requests' do
      options = default_options.merge(:method => 'POST', :host => 'stream.twitter.com', :port => 443)
      req = Twitter::Stream::Request.new(options)
      SimpleOAuth::Header.should_receive(:new).
        with('POST', "http://stream.twitter.com/1.1/statuses/filter.json", {"track"=>"nfl"}, kind_of(Hash))

      req.send(:oauth_header)
    end

    it 'passes params on the querystring for GET requests' do
      options = default_options.merge(:method => 'GET', :host => 'stream.twitter.com', :port => 443)
      req = Twitter::Stream::Request.new(options)
      SimpleOAuth::Header.should_receive(:new).
        with('GET', "http://stream.twitter.com/1.1/statuses/filter.json?track=nfl", {}, kind_of(Hash))

      req.send(:oauth_header)
    end
  end

  describe "#proxy?" do
    it "defaults to false" do
      req = Twitter::Stream::Request.new
      expect(req.proxy?).to be_false
    end

    it "returns true when a proxy is set" do
      req = Twitter::Stream::Request.new(:proxy => proxy_options)
      expect(req.proxy?).to be_true
    end
  end

  describe "#to_s" do
    context "without a proxy" do
      before do
        @request = Twitter::Stream::Request.new(default_options)
      end

      it "requests the defined path" do
        expect(@request.to_s).to include('/1.1/statuses/filter.json')
      end
    end

    context "when using a proxy" do
      before do
        @request = Twitter::Stream::Request.new(default_options.merge(:proxy => proxy_options, :host => '127.0.0.1', :port => 8080))
      end

      it "requests the full uri" do
        expect(@request.to_s).to include("POST http://127.0.0.1:8080/1.1/statuses/filter.json")
      end

      it "includes a Proxy header" do
        expect(@request.to_s).to include('Proxy-Authorization: Basic ')
      end
    end

    context "gzip encoding" do
      before do
        @request = Twitter::Stream::Request.new(default_options.merge(:encoding => 'gzip'))
      end

      it "sets a keep-alive header" do
        expect(@request.to_s).to include('Connection: Keep-Alive')
      end

      it "sets the accept-enconding header" do
        expect(@request.to_s).to include('Accept-Encoding: deflate, gzip')
      end
    end

    it "adds a POST body" do
      @request = Twitter::Stream::Request.new(default_options)
      expect(@request.to_s).to include('track=nfl')
    end

    it "adds query parameters" do
      @request = Twitter::Stream::Request.new(default_options.merge(:method => :get))
      expect(@request.to_s).to include('/1.1/statuses/filter.json?track=nfl')
    end

    it "allows defining a custom user-agent" do
      @request = Twitter::Stream::Request.new(default_options.merge(:user_agent => 'Twitter::Stream Test Suite'))
      expect(@request.to_s).to include('User-Agent: Twitter::Stream Test Suite')
    end

    it "adds an accept header" do
      @request = Twitter::Stream::Request.new(default_options)
      expect(@request.to_s).to include('Accept: */*')
    end

    it "adds custom headers" do
      @request = Twitter::Stream::Request.new(default_options.merge(:headers => { 'foo' => 'bar'}))
      expect(@request.to_s).to include('foo: bar')
    end
  end
end
