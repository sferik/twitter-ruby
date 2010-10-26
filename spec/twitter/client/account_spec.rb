require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".verify_credentials" do

        before do
          stub_get("account/verify_credentials.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.verify_credentials
          a_get("account/verify_credentials.#{format}").
            should have_been_made
        end

        it "should return the requesting user" do
          user = @client.verify_credentials
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".rate_limit_status" do

        before do
          stub_get("account/rate_limit_status.#{format}").
            to_return(:body => fixture("rate_limit_status.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.rate_limit_status
          a_get("account/rate_limit_status.#{format}").
            should have_been_made
        end

        it "should return the remaining number of API requests available to the requesting user before the API limit is reached" do
          rate_limit_status = @client.rate_limit_status
          rate_limit_status.remaining_hits.should == 19993
        end

      end

      describe ".end_session" do

        before do
          stub_post("account/end_session.#{format}").
            to_return(:body => fixture("end_session.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.end_session
          a_post("account/end_session.#{format}").
            should have_been_made
        end

        it "should return a null cookie" do
          end_session = @client.end_session
          end_session.error.should == "Logged out."
        end

      end

    end
  end
end
