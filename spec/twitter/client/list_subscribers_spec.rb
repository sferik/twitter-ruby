require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_subscribers" do

        before do
          stub_get("pengwynn/rubyists/subscribers.#{format}").
            to_return(:body => fixture("list_subscribers.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_subscribers("pengwynn", "rubyists")
          a_get("pengwynn/rubyists/subscribers.#{format}").
            should have_been_made
        end

        it "should return the subscribers of the specified list" do
          list_subscribers = @client.list_subscribers("pengwynn", "rubyists")
          list_subscribers.users.should be_an Array
          list_subscribers.users.first.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".list_subscribe" do

        before do
          stub_post("pengwynn/rubyists/subscribers.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_subscribe("pengwynn", "rubyists")
          a_post("pengwynn/rubyists/subscribers.#{format}").
            should have_been_made
        end

        it "should return the specified list" do
          list = @client.list_subscribe("pengwynn", "rubyists")
          list.name.should == "Rubyists"
        end
      end

      describe ".list_unsubscribe" do

        before do
          stub_delete("pengwynn/rubyists/subscribers.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_unsubscribe("pengwynn", "rubyists")
          a_delete("pengwynn/rubyists/subscribers.#{format}").
            should have_been_made
        end

        it "should return the specified list" do
          list = @client.list_unsubscribe("pengwynn", "rubyists")
          list.name.should == "Rubyists"
        end
      end

      describe ".is_subscriber?" do

        before do
          stub_get("pengwynn/rubyists/subscribers/7505382.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("pengwynn/rubyists/subscribers/14100886.#{format}").
            to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.is_subscriber?("pengwynn", "rubyists", 7505382)
          a_get("pengwynn/rubyists/subscribers/7505382.#{format}").
            should have_been_made
        end

        it "should return true if the specified user subscribes to the specified list" do
          is_subscriber = @client.is_subscriber?("pengwynn", "rubyists", 7505382)
          is_subscriber.should be_true
        end

        it "should return false if the specified user does not subscribe to the specified list" do
          is_subscriber = @client.is_subscriber?("pengwynn", "rubyists", 14100886)
          is_subscriber.should be_false
        end
      end
    end
  end
end
