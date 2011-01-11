require File.expand_path('../../../spec_helper', __FILE__)

describe Twitter::Client do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_create" do

        context "with screen name passed" do

          before do
            stub_post("sferik/lists.#{format}").
              with(:body => {:name => "presidents"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_create("sferik", "presidents")
            a_post("sferik/lists.#{format}").
              with(:body => {:name => "presidents"}).
              should have_been_made
          end

          it "should return the created list" do
            list = @client.list_create("sferik", "presidents")
            list.name.should == "presidents"
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_post("sferik/lists.#{format}").
              with(:body => {:name => "presidents"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_create("presidents")
            a_post("sferik/lists.#{format}").
              with(:body => {:name => "presidents"}).
              should have_been_made
          end

        end

      end

      describe ".list_update" do

        context "with screen name passed" do

          before do
            stub_put("sferik/lists/presidents.#{format}").
              with(:body => {:description => "Presidents of the United States of America"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
            a_put("sferik/lists/presidents.#{format}").
              with(:body => {:description => "Presidents of the United States of America"}).
              should have_been_made
          end

          it "should return the updated list" do
            list = @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
            list.name.should == "presidents"
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_put("sferik/lists/presidents.#{format}").
              with(:body => {:description => "Presidents of the United States of America"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
            a_put("sferik/lists/presidents.#{format}").
              with(:body => {:description => "Presidents of the United States of America"}).
              should have_been_made
          end

        end

      end

      describe ".lists" do

        context "with a screen name passed" do

          before do
            stub_get("sferik/lists.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.lists("sferik")
            a_get("sferik/lists.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the updated list" do
            lists = @client.lists("sferik")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

        context "without arguments passed" do

          before do
            stub_get("lists.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.lists
            a_get("lists.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the updated list" do
            lists = @client.lists
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

      end

      describe ".list" do

        context "with a screen name passed" do

          before do
            stub_get("sferik/lists/presidents.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list("sferik", "presidents")
            a_get("sferik/lists/presidents.#{format}").
              should have_been_made
          end

          it "should return the updated list" do
            list = @client.list("sferik", "presidents")
            list.name.should == "presidents"
          end

        end

        context "without a screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("sferik/lists/presidents.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list("sferik", "presidents")
            a_get("sferik/lists/presidents.#{format}").
              should have_been_made
          end

        end

      end

      describe ".list_delete" do

        context "with a screen name passed" do

          before do
            stub_delete("sferik/lists/presidents.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_delete("sferik", "presidents")
            a_delete("sferik/lists/presidents.#{format}").
              should have_been_made
          end

          it "should return the deleted list" do
            list = @client.list_delete("sferik", "presidents")
            list.name.should == "presidents"
          end

        end

        context "without a screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_delete("sferik/lists/presidents.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_delete("sferik", "presidents")
            a_delete("sferik/lists/presidents.#{format}").
              should have_been_made
          end

        end

      end

      describe ".list_timeline" do

        context "with a screen name passed" do

          before do
            stub_get("sferik/lists/presidents/statuses.#{format}").
              to_return(:body => fixture("statuses.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_timeline("sferik", "presidents")
            a_get("sferik/lists/presidents/statuses.#{format}").
              should have_been_made
          end

          it "should return the tweet timeline for members of the specified list" do
            statuses = @client.list_timeline("sferik", "presidents")
            statuses.should be_an Array
            statuses.first.text.should == "Ruby is the best programming language for hiding the ugly bits."
          end

        end

        context "without a screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("sferik/lists/presidents/statuses.#{format}").
              to_return(:body => fixture("statuses.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_timeline("sferik", "presidents")
            a_get("sferik/lists/presidents/statuses.#{format}").
              should have_been_made
          end

          it "should return the tweet timeline for members of the specified list" do
            statuses = @client.list_timeline("sferik", "presidents")
            statuses.should be_an Array
            statuses.first.text.should == "Ruby is the best programming language for hiding the ugly bits."
          end

        end

      end

      describe ".memberships" do

        context "with a screen name passed" do

          before do
            stub_get("pengwynn/lists/memberships.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.memberships("pengwynn")
            a_get("pengwynn/lists/memberships.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the lists the specified user has been added to" do
            lists = @client.memberships("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

        context "without a screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("pengwynn/lists/memberships.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.memberships("pengwynn")
            a_get("pengwynn/lists/memberships.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the lists the specified user has been added to" do
            lists = @client.memberships("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

      end

      describe ".subscriptions" do

        context "with a screen name passed" do

          before do
            stub_get("pengwynn/lists/subscriptions.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.subscriptions("pengwynn")
            a_get("pengwynn/lists/subscriptions.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the lists the specified user follows" do
            lists = @client.subscriptions("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

        context "without a screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("pengwynn/lists/subscriptions.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("lists.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.subscriptions("pengwynn")
            a_get("pengwynn/lists/subscriptions.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the lists the specified user follows" do
            lists = @client.subscriptions("pengwynn")
            lists.lists.should be_an Array
            lists.lists.first.name.should == "Rubyists"
          end

        end

      end

    end
  end
end
