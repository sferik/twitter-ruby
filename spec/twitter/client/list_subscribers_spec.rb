require File.expand_path('../../../spec_helper', __FILE__)

describe Twitter::Client do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_subscribers" do

        before do
          stub_get("sferik/presidents/subscribers.#{format}").
            with(:query => {:cursor => "-1"}).
            to_return(:body => fixture("users_list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_subscribers("sferik", "presidents")
          a_get("sferik/presidents/subscribers.#{format}").
            with(:query => {:cursor => "-1"}).
            should have_been_made
        end

        it "should return the subscribers of the specified list" do
          users_list = @client.list_subscribers("sferik", "presidents")
          users_list.users.should be_an Array
          users_list.users.first.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".list_subscribe" do

        before do
          stub_post("sferik/presidents/subscribers.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_subscribe("sferik", "presidents")
          a_post("sferik/presidents/subscribers.#{format}").
            should have_been_made
        end

        it "should return the specified list" do
          list = @client.list_subscribe("sferik", "presidents")
          list.name.should == "presidents"
        end

      end

      describe ".list_unsubscribe" do

        before do
          stub_delete("sferik/presidents/subscribers.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_unsubscribe("sferik", "presidents")
          a_delete("sferik/presidents/subscribers.#{format}").
            should have_been_made
        end

        it "should return the specified list" do
          list = @client.list_unsubscribe("sferik", "presidents")
          list.name.should == "presidents"
        end

      end

      describe ".is_subscriber?" do

        before do
          stub_get("sferik/presidents/subscribers/813286.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("sferik/presidents/subscribers/18755393.#{format}").
            to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.is_subscriber?("sferik", "presidents", 813286)
          a_get("sferik/presidents/subscribers/813286.#{format}").
            should have_been_made
        end

        it "should return true if the specified user subscribes to the specified list" do
          is_subscriber = @client.is_subscriber?("sferik", "presidents", 813286)
          is_subscriber.should be_true
        end

        it "should return false if the specified user does not subscribe to the specified list" do
          is_subscriber = @client.is_subscriber?("sferik", "presidents", 18755393)
          is_subscriber.should be_false
        end
      end
    end
  end
end
