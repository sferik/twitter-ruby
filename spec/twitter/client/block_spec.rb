require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".block" do

        before do
          stub_post("blocks/create.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.block("sferik")
            a_post("blocks/create.#{format}").
              should have_been_made
          end

          it "should return the blocked user" do
            user = @auth_client.block("sferik")
            user.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.block("sferik")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".unblock" do

        before do
          stub_delete("blocks/destroy.#{format}?screen_name=sferik").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.unblock("sferik")
            a_delete("blocks/destroy.#{format}?screen_name=sferik").
              should have_been_made
          end

          it "should return the un-blocked user" do
            user = @auth_client.unblock("sferik")
            user.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.unblock("sferik")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".block_exists?" do

        before do
          stub_get("blocks/exists.#{format}?screen_name=sferik").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("blocks/exists.#{format}?screen_name=pengwynn").
            to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.block_exists?("sferik")
            a_get("blocks/exists.#{format}?screen_name=sferik").
              should have_been_made
          end

          it "should return true if block exists" do
            block_exists = @auth_client.block_exists?("sferik")
            block_exists.should be_true
          end

          it "should return false if block does not exists" do
            block_exists = @auth_client.block_exists?("pengwynn")
            block_exists.should be_false
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.block_exists?("sferik")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".blocking" do

        before do
          stub_get("blocks/blocking.#{format}").
            to_return(:body => fixture("users.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.blocking
            a_get("blocks/blocking.#{format}").
              should have_been_made
          end

          it "should return an array of user objects that the authenticating user is blocking" do
            users = @auth_client.blocking
            users.should be_an Array
            users.first.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.blocking
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".blocked_ids" do

        before do
          stub_get("blocks/blocking/ids.#{format}").
            to_return(:body => fixture("ids.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.blocked_ids
            a_get("blocks/blocking/ids.#{format}").
              should have_been_made
          end

          it "should return an array of numeric user ids the authenticating user is blocking" do
            ids = @auth_client.blocked_ids
            ids.should be_an Array
            ids.first.should == 47
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.blocked_ids
            end.should raise_error Twitter::Unauthorized
          end
        end
      end
    end
  end
end
