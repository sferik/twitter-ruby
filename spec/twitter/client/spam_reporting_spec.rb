require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".report_spam" do

        before do
          stub_post("report_spam.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.report_spam("sferik")
            a_post("report_spam.#{format}").
              should have_been_made
          end

          it "should return the specified user" do
            user = @auth_client.report_spam("sferik")
            user.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.report_spam("sferik")
            end.should raise_error Twitter::Unauthorized
          end
        end
      end
    end
  end
end
