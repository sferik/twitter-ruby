require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".images" do
    before do
      stub_get("/i/search/image_facets.json").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("image_facets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.images('twitter')
      a_get("/i/search/image_facets.json").
        with(:query => {:q => "twitter"}).
        with(:headers => {'X-Phx' => 'true'}).
        should have_been_made
    end
    it "should return recent statuses that contain images related to a query" do
      images = @client.images('twitter')
      images.should be_an Array
      images.first.should be_a Twitter::Status
      images.first.text.should == "Thanks Twitter family! Beautiful. Cc @laurelstout @seacue @janetvh @mgale @choppedonion  http://t.co/drAqoba"
    end
  end

  describe ".videos" do
    before do
      stub_get("/i/search/video_facets.json").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("video_facets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.videos('twitter')
      a_get("/i/search/video_facets.json").
        with(:query => {:q => "twitter"}).
        with(:headers => {'X-Phx' => 'true'}).
        should have_been_made
    end
    it "should return recent statuses that contain videos related to a query" do
      videos = @client.videos('twitter')
      videos.should be_an Array
      videos.first.should be_a Twitter::Status
      videos.first.text.should == "@Foofighters LEGENDS with a Legendary set of Music Videos http://t.co/IcVGIQO #VMA #VEVO"
    end
  end

  describe ".search" do
    before do
      stub_get("/search.json", Twitter.search_endpoint).
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("/search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.search('twitter')
      a_get("/search.json", Twitter.search_endpoint).
        with(:query => {:q => "twitter"}).
        should have_been_made
    end
    it "should return recent statuses related to a query with images and videos embedded" do
      search = @client.search('twitter')
      search.should be_an Array
      search.first.should be_a Twitter::Status
      search.first.text.should == "@KaiserKuo from not too far away your new twitter icon looks like Vader."
    end
  end

  describe ".phoenix_search" do
    before do
      stub_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("phoenix_search.phoenix"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.phoenix_search('twitter')
      a_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        with(:headers => {'X-Phx' => 'true'}).
        should have_been_made
    end
    it "should return recent statuses related to a query with images and videos embedded" do
      search = @client.phoenix_search('twitter')
      search.should be_an Array
      search.first.should be_a Twitter::Status
      search.first.text.should == "looking at twitter trends just makes me realize how little i really understand about mankind."
    end
  end

end
