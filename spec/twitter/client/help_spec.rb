require 'helper'

describe Twitter::Client do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".configuration" do

        before do
          stub_get("help/configuration.#{format}").
            to_return(:body => fixture("configuration.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.configuration
          a_get("help/configuration.#{format}").
            should have_been_made
        end

        it "should return Twitter's current configuration" do
          configuration = @client.configuration
          configuration.characters_reserved_per_media.to_s.should == '20'
        end

      end

      describe ".languages" do

        before do
          stub_get("help/languages.#{format}").
            to_return(:body => fixture("languages.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.languages
          a_get("help/languages.#{format}").
            should have_been_made
        end

        it "should return the list of languages supported by Twitter" do
          languages = @client.languages
          languages.first.name.should == "Portuguese"
        end
      end
    end
  end
end
