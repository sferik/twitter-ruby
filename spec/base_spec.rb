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
      @base.timeline(:public).size.should == 20
    end
    
    it "should be able to retrieve user timeline" do
      data = open(File.dirname(__FILE__) + '/fixtures/user_timeline.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.timeline(:user).size.should == 19
    end
  end
  
  describe "friends" do
    it "should be able to get friends" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.friends.size.should == 100
    end
    
    it "should be able to get friends without latest status" do
      data = open(File.dirname(__FILE__) + '/fixtures/friends_lite.xml').read
      @base.should_receive(:request).and_return(Hpricot::XML(data))
      @base.friends(:lite => true).size.should == 100
    end
  end
end