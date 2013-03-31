require 'helper'

describe Twitter::Stream::Proxy do
  let(:proxy_options) { { :uri => 'http://my-proxy:8080', :user => 'username', :password => 'password' } }
  describe ".new" do
    it "interprets a proxy configuration" do
      proxy = Twitter::Stream::Proxy.new(proxy_options)
      expect(proxy.user).to eq('username')
      expect(proxy.password).to eq('password')
      expect(proxy.uri).to eq('http://my-proxy:8080')
    end
  end

  describe "#header" do
    it "returns false when no proxy credentials are passed" do
      expect(Twitter::Stream::Proxy.new.header).to be_false
    end

    it "generates a header when passed credentials" do
      proxy = Twitter::Stream::Proxy.new(proxy_options)
      expect(proxy.header).to be
    end
  end
end
