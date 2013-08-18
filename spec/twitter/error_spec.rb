require 'helper'

describe Twitter::Error do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#message" do
    it "returns the message of the wrapped exception" do
      error = Twitter::Error.new(Faraday::Error::ClientError.new("Oops"))
      expect(error.message).to eq("Oops")
    end
  end

  describe "#rate_limit" do
    it "returns the wrapped exception" do
      error = Twitter::Error.new(Faraday::Error::ClientError.new("Oops"))
      expect(error.rate_limit).to be_a Twitter::RateLimit
    end
  end

  describe "#wrapped_exception" do
    it "returns the wrapped exception" do
      error = Twitter::Error.new(Faraday::Error::ClientError.new("Oops"))
      expect(error.wrapped_exception.class).to eq(Faraday::Error::ClientError)
    end
  end

  Twitter::Error.errors.each do |status, exception|

    [nil, "error", "errors"].each do |body|
      context "when HTTP status is #{status} and body is #{body.inspect}" do
        before do
          body_message = '{"' + body + '":"Client Error"}' unless body.nil?
          stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:status => status, :body => body_message)
        end
        it "raises #{exception.name}" do
          expect{@client.user_timeline("sferik")}.to raise_error exception
        end
      end
    end

    context "when HTTP status is #{status} and body is errors" do
      context "when errors is an array of hashes" do
        context "when error code is nil" do
          before do
            body_message = '{"errors":[{"message":"Client Error"}]}'
            stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:status => status, :body => body_message)
          end
          it "raises #{exception.name}" do
            expect{@client.user_timeline("sferik")}.to raise_error{|error| expect(error.code).to be_nil}
          end
          context "when error code is 187" do
            before do
              body_message = '{"errors":[{"message":"Client Error","code":187}]}'
              stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:status => status, :body => body_message)
            end
            it "raises #{exception.name}" do
              expect{@client.user_timeline("sferik")}.to raise_error{|error| expect(error.code).to eq(187)}
            end
          end
        end
      end
    end

  end
end
