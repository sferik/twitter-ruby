require 'helper'

describe Twitter::Client do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
      end

      describe ".images" do

        before do
          stub_get("i/search/image_facets.#{format}").
            with(:query => {:q => "twitter"}).
            to_return(:body => fixture("image_facets.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.images('twitter')
          a_get("i/search/image_facets.#{format}").
            with(:query => {:q => "twitter"}).
            with(:headers => {'X-Phx' => 'true'}).
            should have_been_made
        end

        it "should return recent statuses that contain images related to a query" do
          images = @client.images('twitter')
          images.first.text.should == "Thanks Twitter family! Beautiful. Cc @laurelstout @seacue @janetvh @mgale @choppedonion  http://t.co/drAqoba"
        end

      end

      describe ".videos" do

        before do
          stub_get("i/search/video_facets.#{format}").
            with(:query => {:q => "twitter"}).
            to_return(:body => fixture("video_facets.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.videos('twitter')
          a_get("i/search/video_facets.#{format}").
            with(:query => {:q => "twitter"}).
            with(:headers => {'X-Phx' => 'true'}).
            should have_been_made
        end

        it "should return recent statuses that contain videos related to a query" do
          videos = @client.videos('twitter')
          videos.first.text.should == "@Foofighters LEGENDS with a Legendary set of Music Videos http://t.co/IcVGIQO #VMA #VEVO"
        end
      end

      describe ".search" do

        before do
          stub_get("phoenix_search.phoenix").
            with(:query => {:q => "twitter"}).
            to_return(:body => fixture("phoenix_search.phoenix"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.search('twitter')
          a_get("phoenix_search.phoenix").
            with(:query => {:q => "twitter"}).
            with(:headers => {'X-Phx' => 'true'}).
            should have_been_made
        end

        it "should return recent statuses related to a query with images and videos embedded" do
          search = @client.search('twitter')
          search.first.text.should == "looking at twitter trends just makes me realize how little i really understand about mankind."
        end
      end
    end
  end
end
