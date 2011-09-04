require 'helper'

describe Twitter::Client do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
      end

      describe ".tos" do

        before do
          stub_get("1/legal/tos.#{format}").
            to_return(:body => fixture("tos.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.tos
          a_get("1/legal/tos.#{format}").
            should have_been_made
        end

        it "should return Twitter's Terms of Service" do
          tos = @client.tos
          tos.split.first.should == "Terms"
        end

      end

      describe ".privacy" do

        before do
          stub_get("1/legal/privacy.#{format}").
            to_return(:body => fixture("privacy.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.privacy
          a_get("1/legal/privacy.#{format}").
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
