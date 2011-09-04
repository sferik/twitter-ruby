require 'helper'

describe Twitter::Client do
  %w(json xml).each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format)
      end

      describe ".image_facets" do

        before do
          stub_get("search/image_facets.#{format}").
            with(:query => {:q => "twitter"}).
            to_return(:body => fixture("image_facets.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.image_facets('twitter')
          a_get("search/image_facets.#{format}").
            with(:query => {:q => "twitter"}).
            should have_been_made
        end

        it "should return a single status" do
          image_facets = @client.image_facets('twitter')
          image_facets.first.text.should == "Thanks Twitter family! Beautiful. Cc @laurelstout @seacue @janetvh @mgale @choppedonion  http://t.co/drAqoba"
        end

      end

      describe ".video_facets" do

        before do
          stub_get("search/video_facets.#{format}").
            with(:query => {:q => "twitter"}).
            to_return(:body => fixture("video_facets.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.video_facets('twitter')
          a_get("search/video_facets.#{format}").
            with(:query => {:q => "twitter"}).
            should have_been_made
        end

        it "should return a single status" do
          video_facets = @client.video_facets('twitter')
          video_facets.first.text.should == "@Foofighters LEGENDS with a Legendary set of Music Videos http://t.co/IcVGIQO #VMA #VEVO"
        end
      end
    end
  end
end
