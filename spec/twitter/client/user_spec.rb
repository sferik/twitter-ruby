require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".user" do

        before do
          stub_get("users/show.#{format}").
            with(:query => {"screen_name" => "sferik"}).
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @auth_client.user("sferik")
          a_get("users/show.#{format}").
            with(:query => {"screen_name" => "sferik"}).
            should have_been_made
        end

        it "should return extended information of a given user" do
          user = @auth_client.user("sferik")
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".users" do

        before do
          stub_get("users/lookup.#{format}?screen_name=sferik,pengwynn").
            to_return(:body => fixture("users.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @auth_client.users(["sferik", "pengwynn"])
          a_get("users/lookup.#{format}?screen_name=sferik,pengwynn").
            should have_been_made
        end

        it "should return up to 100 users worth of extended information" do
          users = @auth_client.users(["sferik", "pengwynn"])
          users.should be_a Array
          users.first.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".user_search" do

        before do
          stub_get("users/search.#{format}?q=Erik+Michaels-Ober").
            to_return(:body => fixture("user_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @auth_client.user_search("Erik Michaels-Ober")
          a_get("users/search.#{format}?q=Erik Michaels-Ober").
            should have_been_made
        end

        it "should return an array of user search results" do
          user_search = @auth_client.user_search("Erik Michaels-Ober")
          user_search.should be_a Array
          user_search.first.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".suggestions" do

        context "with no arguments passed" do

          before do
            stub_get("users/suggestions.#{format}").
              to_return(:body => fixture("suggestions.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @auth_client.suggestions
            a_get("users/suggestions.#{format}").
              should have_been_made
          end

          it "should return the list of suggested user categories" do
            suggestions = @auth_client.suggestions
            suggestions.should be_a Array
            suggestions.first.name.should == "Art & Design"
          end

        end

        context "with a category slug passed" do

          before do
            stub_get("users/suggestions/art-design.#{format}").
              to_return(:body => fixture("category.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @auth_client.suggestions("art-design")
            a_get("users/suggestions/art-design.#{format}").
              should have_been_made
          end

          it "should return the users in a given category of the Twitter suggested user list" do
            category = @auth_client.suggestions("art-design")
            category.name.should == "Art & Design"
          end

        end

      end

      describe ".profile_image" do

        before do
          stub_get("users/profile_image/sferik.#{format}").
            to_return(fixture("profile_image.text"))
        end

        it "should redirect to the correct resource" do
          profile_image = @auth_client.profile_image("sferik")
          a_get("users/profile_image/sferik.#{format}").
            with(:status => 302).
            should have_been_made
          profile_image.should == "http://a0.twimg.com/profile_images/323331048/me_normal.jpg"
        end

      end

      describe ".friends" do

        context "with authentication" do

          context "with no arguments passed" do

            before do
              stub_get("statuses/friends.#{format}").
                to_return(:body => fixture("friends.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
            end

            it "should get the correct resource" do
              @auth_client.friends
              a_get("statuses/friends.#{format}").
                should have_been_made
            end

            it "should return a user's friends, each with current status inline" do
              friends = @auth_client.friends
              friends.should be_a Array
              friends.first.name.should == "kellan"
            end

          end

        end

        context "with a screen name passed" do

          before do
            stub_get("statuses/friends.#{format}").
              with(:query => {"screen_name" => "sferik"}).
              to_return(:body => fixture("friends.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @auth_client.friends("sferik")
            a_get("statuses/friends.#{format}").
              with(:query => {"screen_name" => "sferik"}).
              should have_been_made
          end

          it "should return a user's friends, each with current status inline" do
            friends = @auth_client.friends("sferik")
            friends.should be_a Array
            friends.first.name.should == "kellan"
          end

        end

      end

      describe ".followers" do

        before do
          stub_get("statuses/followers.#{format}").
            to_return(:body => fixture("followers.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("statuses/followers.#{format}").
            with(:query => {"screen_name" => "sferik"}).
            to_return(:body => fixture("followers.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          context "with a screen name passed" do

            it "should get the correct resource" do
              @auth_client.followers("sferik")
              a_get("statuses/followers.#{format}").
                with(:query => {"screen_name" => "sferik"}).
                should have_been_made
            end

            it "should return a user's followers, each with current status inline" do
              followers = @auth_client.followers("sferik")
              followers.should be_a Array
              followers.first.name.should == "samz sasuke"
            end

          end

          context "with no arguments passed" do

            it "should get the correct resource" do
              @auth_client.followers
              a_get("statuses/followers.#{format}").
                should have_been_made
            end

            it "should return a user's followers, each with current status inline" do
              followers = @auth_client.followers
              followers.should be_a Array
              followers.first.name.should == "samz sasuke"
            end

          end

        end

        context "without authentication" do

          context "with a screen name passed" do

            it "should get the correct resource" do
              @client.followers("sferik")
              a_get("statuses/followers.#{format}").
                with(:query => {"screen_name" => "sferik"}).
                should have_been_made
            end

            it "should return a user's followers, each with current status inline" do
              followers = @client.followers("sferik")
              followers.should be_a Array
              followers.first.name.should == "samz sasuke"
            end

          end

          context "with no arguments passed" do

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
end
