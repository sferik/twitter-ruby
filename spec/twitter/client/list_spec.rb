require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_create" do

        before do
          stub_post("pengwynn/lists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_create("pengwynn", "Rubyists")
          a_post("pengwynn/lists.#{format}").
            should have_been_made
        end

        it "should return the created list" do
          list = @client.list_create("pengwynn", "Rubyists")
          list.name.should == "Rubyists"
        end

      end

      describe ".list_update" do

        before do
          stub_put("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_update("pengwynn", "Rubyists")
          a_put("pengwynn/lists/Rubyists.#{format}").
            should have_been_made
        end

        it "should return the updated list" do
          list = @client.list_update("pengwynn", "Rubyists")
          list.name.should == "Rubyists"
        end

      end

      describe ".lists" do

        context "with no arguments passed" do

          before do
            stub_get("lists.#{format}").
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.lists
            a_get("lists.#{format}").
              should have_been_made
          end

          it "should return the updated list" do
            lists = @client.lists
            lists.lists.should be_an Array
            lists.lists.first.name.should == "things-to-attend"
          end

        end

        context "with a screen_name passed" do

          before do
            stub_get("pengwynn/lists.#{format}").
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.lists("pengwynn")
            a_get("pengwynn/lists.#{format}").
              should have_been_made
          end

          it "should return the updated list" do
            lists = @client.lists("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "things-to-attend"
          end

        end

      end

      describe ".list" do

        before do
          stub_get("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list("pengwynn", "Rubyists")
          a_get("pengwynn/lists/Rubyists.#{format}").
            should have_been_made
        end

        it "should return the updated list" do
          list = @client.list("pengwynn", "Rubyists")
          list.name.should == "Rubyists"
        end

      end

      describe ".list_delete" do

        before do
          stub_delete("pengwynn/lists/Rubyists.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_delete("pengwynn", "Rubyists")
          a_delete("pengwynn/lists/Rubyists.#{format}").
            should have_been_made
        end

        it "should return the deleted list" do
          list = @client.list_delete("pengwynn", "Rubyists")
          list.name.should == "Rubyists"
        end

      end

      describe ".list_timeline" do

        before do
          stub_get("pengwynn/lists/Rubyists/statuses.#{format}").
            to_return(:body => fixture("statuses.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_timeline("pengwynn", "Rubyists")
          a_get("pengwynn/lists/Rubyists/statuses.#{format}").
            should have_been_made
        end

        it "should return the tweet timeline for members of the specified list" do
          statuses = @client.list_timeline("pengwynn", "Rubyists")
          statuses.should be_an Array
          statuses.first.text.should == "@nzkoz Doh. So give me 3 good alternatives to choose from with lightweight collaboration/change tracking/image insertion? cc:@polarbearfarm"
        end

      end

      describe ".memberships" do

        before do
          stub_get("pengwynn/lists/memberships.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.memberships("pengwynn")
          a_get("pengwynn/lists/memberships.#{format}").
            should have_been_made
        end

        it "should return the lists the specified user has been added to" do
          lists = @client.memberships("pengwynn")
          lists.lists.should be_an Array
          lists.lists.first.name.should == "things-to-attend"
        end

      end

      describe ".subscriptions" do

        before do
          stub_get("pengwynn/lists/subscriptions.#{format}").
            to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.subscriptions("pengwynn")
          a_get("pengwynn/lists/subscriptions.#{format}").
            should have_been_made
        end

        it "should return the lists the specified user follows" do
          lists = @client.subscriptions("pengwynn")
          lists.lists.should be_an Array
          lists.lists.first.name.should == "things-to-attend"
        end
      end
    end
  end
end
