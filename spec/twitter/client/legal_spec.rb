require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
        @client = Twitter::Client.new(:format => format)
      end

      describe ".tos" do

        before do
          stub_get("legal/tos.#{format}").
            to_return(:body => fixture("tos.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.tos
            a_get("legal/tos.#{format}").
              should have_been_made
          end

          it "should return Twitter's Terms of Service" do
            tos = @auth_client.tos
            tos.split.first.should == "Terms"
          end

        end

        context "without authentication" do

          it "should get the correct resource" do
            @client.tos
            a_get("legal/tos.#{format}").
              should have_been_made
          end

          it "should return Twitter's Terms of Service" do
            tos = @client.tos
            tos.split.first.should == "Terms"
          end

        end

      end

      describe ".privacy" do

        before do
          stub_get("legal/privacy.#{format}").
            to_return(:body => fixture("privacy.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.privacy
            a_get("legal/privacy.#{format}").
              should have_been_made
          end

          it "should return Twitter's Privacy Policy" do
            privacy = @auth_client.privacy
            privacy.split.first.should == "Twitter"
          end

        end

        context "without authentication" do

          it "should get the correct resource" do
            @client.privacy
            a_get("legal/privacy.#{format}").
              should have_been_made
          end

          it "should return Twitter's Privacy Policy" do
            privacy = @client.privacy
            privacy.split.first.should == "Twitter"
          end
        end
      end
    end
  end
end
