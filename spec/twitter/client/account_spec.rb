require 'helper'

describe Twitter::Client do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
      end

      describe ".verify_credentials" do

        before do
          stub_get("1/account/verify_credentials.#{format}").
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.verify_credentials
          a_get("1/account/verify_credentials.#{format}").
            should have_been_made
        end

        it "should return the requesting user" do
          user = @client.verify_credentials
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".rate_limit_status" do

        before do
          stub_get("1/account/rate_limit_status.#{format}").
            to_return(:body => fixture("rate_limit_status.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.rate_limit_status
          a_get("1/account/rate_limit_status.#{format}").
            should have_been_made
        end

        it "should return the remaining number of API requests available to the requesting user before the API limit is reached" do
          rate_limit_status = @client.rate_limit_status
          rate_limit_status.remaining_hits.should == 19993
        end

      end

      describe ".end_session" do

        before do
          stub_post("1/account/end_session.#{format}").
            to_return(:body => fixture("end_session.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.end_session
          a_post("1/account/end_session.#{format}").
            should have_been_made
        end

        it "should return a null cookie" do
          end_session = @client.end_session
          end_session.error.should == "Logged out."
        end

      end

      describe ".update_delivery_device" do

        before do
          stub_post("1/account/update_delivery_device.#{format}").
            with(:body => {:device => "sms"}).
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.update_delivery_device("sms")
          a_post("1/account/update_delivery_device.#{format}").
            with(:body => {:device => "sms"}).
            should have_been_made
        end

        it "should return a null cookie" do
          user = @client.update_delivery_device("sms")
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".update_profile_colors" do

        before do
          stub_post("1/account/update_profile_colors.#{format}").
            with(:body => {:profile_background_color => "000000"}).
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.update_profile_colors(:profile_background_color => "000000")
          a_post("1/account/update_profile_colors.#{format}").
            with(:body => {:profile_background_color => "000000"}).
            should have_been_made
        end

        it "should return a null cookie" do
          user = @client.update_profile_colors(:profile_background_color => "000000")
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".update_profile_image" do

        before do
          stub_post("1/account/update_profile_image.#{format}").
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.update_profile_image(fixture("me.jpeg"))
          a_post("1/account/update_profile_image.#{format}").
            should have_been_made
        end

        it "should return a null cookie" do
          user = @client.update_profile_image(fixture("me.jpeg"))
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".update_profile_background_image" do

        before do
          stub_post("1/account/update_profile_background_image.#{format}").
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.update_profile_background_image(fixture("we_concept_bg2.png"))
          a_post("1/account/update_profile_background_image.#{format}").
            should have_been_made
        end

        it "should return a null cookie" do
          user = @client.update_profile_background_image(fixture("we_concept_bg2.png"))
          user.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".update_profile" do

        before do
          stub_post("1/account/update_profile.#{format}").
            with(:body => {:url => "http://github.com/sferik/"}).
            to_return(:body => fixture("sferik.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.update_profile(:url => "http://github.com/sferik/")
          a_post("1/account/update_profile.#{format}").
            with(:body => {:url => "http://github.com/sferik/"}).
            should have_been_made
        end

        it "should return a null cookie" do
          user = @client.update_profile(:url => "http://github.com/sferik/")
          user.name.should == "Erik Michaels-Ober"
        end
      end

      describe ".totals" do

        before do
          stub_get("1/account/totals.#{format}").
            to_return(:body => fixture("totals.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.totals
          a_get("1/account/totals.#{format}").
            should have_been_made
        end

      end

      describe ".settings" do

        before do
          stub_get("1/account/settings.#{format}").
            to_return(:body => fixture("settings.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_post("1/account/settings.#{format}").
            with(:body => {:trend_location_woeid => "23424803"}).
            to_return(:body => fixture("settings.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource on GET" do
          @client.settings
          a_get("1/account/settings.#{format}").
            should have_been_made
        end

        it "should get the correct resource on POST" do
          @client.settings(:trend_location_woeid => "23424803")
          a_post("1/account/settings.#{format}").
            with(:body => {:trend_location_woeid => "23424803"}).
            should have_been_made
        end

      end

    end
  end
end
