require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Twitter::Base" do
  before do
    @base = Twitter::Base.new('foo', 'bar')
  end
  
  describe "class methods" do
    it "should should have timelines" do
      Twitter::Base.timelines.should == [:friends, :public, :user]
    end
  end  
  
  describe "being initialized" do
    it "should require email and password" do
      lambda { Twitter::Base.new }.should raise_error(ArgumentError)
    end
  end
  
  describe "timelines" do
    it "should bomb if given invalid timeline" do
      lambda { @base.timeline(:fakeyoutey) }.should raise_error(Twitter::UnknownTimeline)
    end
    
    it "should default to friends timeline"
    
    it "should be able to retrieve friends timeline" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends_timeline.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.timeline(:friends).size.should == 3
    end
    
    it "should be able to retrieve public timeline" do
      data = open(File.dirname(__FILE__) + '/fixtures/public_timeline.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.timeline(:public).size.should == 6
    end
    
    it "should be able to retrieve user timeline" do
      data = open(File.dirname(__FILE__) + '/fixtures/user_timeline.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.timeline(:user).size.should == 19
    end
  end
  
  describe "friends and followers" do
    it "should be able to get friends" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.friends.size.should == 25
    end
    
    it "should be able to get friends without latest status" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends_lite.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.friends(:lite => true).size.should == 15
    end
    
    it "should be able to get friends for another user" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends_for.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      timeline = @base.friends_for(20)
      timeline.size.should == 24
      timeline.first.name.should == 'Jack Dorsey'
    end
    
    it "should be able to get followers" do
      data = open(File.dirname(__FILE__) + '/fixtures/followers.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      timeline = @base.followers
      timeline.size.should == 29
      timeline.first.name.should == 'Blaine Cook'
    end
  end
  
  it "should be able to get single status" do
    data = open(File.dirname(__FILE__) + '/fixtures/status.xml').read
    @base.should_receive(:request).and_return(Hpricot::XML(data))
    @base.status(803478581).created_at.should == 'Sun May 04 23:36:14 +0000 2008'
  end
  
  it "should be able to get single user" do
    data = open(File.dirname(__FILE__) + '/fixtures/user.xml').read
    @base.should_receive(:request).and_return(Hpricot::XML(data))
    @base.user('4243').name.should == 'John Nunemaker'
  end
end