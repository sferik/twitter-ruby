require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_create" do

        before do
          stub_post("pengwynn/lists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.list_create("pengwynn", "Rubyists")
            a_post("pengwynn/lists.#{format}").
              should have_been_made
          end

          it "should return the created list" do
            list = @auth_client.list_create("pengwynn", "Rubyists")
            list.name.should == "Rubyists"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.list_create("pengwynn", "Rubyists")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".list_update" do

        before do
          stub_put("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.list_update("pengwynn", "Rubyists")
            a_put("pengwynn/lists/Rubyists.#{format}").
              should have_been_made
          end

          it "should return the updated list" do
            list = @auth_client.list_update("pengwynn", "Rubyists")
            list.name.should == "Rubyists"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.list_update("pengwynn", "Rubyists")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".lists" do

        before do
          stub_get("pengwynn/lists.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("lists.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          context "with a screen name passed" do

            it "should get the correct resource" do
              @auth_client.lists("pengwynn")
              a_get("pengwynn/lists.#{format}").
                should have_been_made
            end

            it "should return the updated list" do
              lists = @auth_client.lists("pengwynn")
              lists.lists.should be_an Array
              lists.lists.first.name.should == "things-to-attend"
            end

          end

          context "without arguments passed" do

            it "should get the correct resource" do
              @auth_client.lists
              a_get("lists.#{format}").
                should have_been_made
            end

            it "should return the updated list" do
              lists = @auth_client.lists
              lists.lists.should be_an Array
              lists.lists.first.name.should == "things-to-attend"
            end

          end

        end

        context "without authentication" do

          context "with a screen name passed" do

            it "should raise Twitter::Unauthorized" do
              lambda do
                @client.lists("pengwynn")
              end.should raise_error Twitter::Unauthorized
            end

          end

          context "without arguments passed" do

            it "should raise Twitter::Unauthorized" do
              lambda do
                @client.lists
              end.should raise_error Twitter::Unauthorized
            end

          end

        end

      end

      describe ".list" do

        before do
          stub_get("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.list("pengwynn", "Rubyists")
            a_get("pengwynn/lists/Rubyists.#{format}").
              should have_been_made
          end

          it "should return the updated list" do
            list = @auth_client.list("pengwynn", "Rubyists")
            list.name.should == "Rubyists"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.list("pengwynn", "Rubyists")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".list_delete" do

        before do
          stub_delete("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.list_delete("pengwynn", "Rubyists")
            a_delete("pengwynn/lists/Rubyists.#{format}").
              should have_been_made
          end

          it "should return the deleted list" do
            list = @auth_client.list_delete("pengwynn", "Rubyists")
            list.name.should == "Rubyists"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.list_delete("pengwynn", "Rubyists")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".list_timeline" do

        before do
          stub_get("pengwynn/lists/Rubyists/statuses.#{format}").
            to_return(:body => fixture("statuses.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.list_timeline("pengwynn", "Rubyists")
            a_get("pengwynn/lists/Rubyists/statuses.#{format}").
              should have_been_made
          end

          it "should return the tweet timeline for members of the specified list" do
            statuses = @auth_client.list_timeline("pengwynn", "Rubyists")
            statuses.should be_an Array
            statuses.first.text.should == "@nzkoz Doh. So give me 3 good alternatives to choose from with lightweight collaboration/change tracking/image insertion? cc:@polarbearfarm"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.list_timeline("pengwynn", "Rubyists")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".memberships" do

        before do
          stub_get("pengwynn/lists/memberships.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.memberships("pengwynn")
            a_get("pengwynn/lists/memberships.#{format}").
              should have_been_made
          end

          it "should return the lists the specified user has been added to" do
            lists = @auth_client.memberships("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "things-to-attend"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.memberships("pengwynn")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".subscriptions" do

        before do
          stub_get("pengwynn/lists/subscriptions.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.subscriptions("pengwynn")
            a_get("pengwynn/lists/subscriptions.#{format}").
              should have_been_made
          end

          it "should return the lists the specified user follows" do
            lists = @auth_client.subscriptions("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "things-to-attend"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.subscriptions("pengwynn")
            end.should raise_error Twitter::Unauthorized
          end
        end
      end
    end
  end
end
