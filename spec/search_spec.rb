require File.dirname(__FILE__) + '/spec_helper.rb'

describe Twitter::Search do
  before do
    @search = Twitter::Search.new
  end
  
  it "should be able to initialize with a search term" do
    Twitter::Search.new('httparty').query[:q].should include('httparty')
  end
  
  it "should be able to specify from" do
    @search.from('jnunemaker').query[:q].should include('from:jnunemaker')
  end
  
  it "should be able to specify to" do
    @search.to('jnunemaker').query[:q].should include('to:jnunemaker')
  end
  
  it "should be able to specify referencing" do
    @search.referencing('jnunemaker').query[:q].should include('@jnunemaker')
  end
  
  it "should alias references to referencing" do
    @search.references('jnunemaker').query[:q].should include('@jnunemaker')
  end
  
  it "should alias ref to referencing" do
    @search.ref('jnunemaker').query[:q].should include('@jnunemaker')
  end
  
  it "should be able to specify containing" do
    @search.containing('milk').query[:q].should include('milk')
  end
  
  it "should alias contains to containing" do
    @search.contains('milk').query[:q].should include('milk')
  end  
  
  it "should be able to specify hashed" do
    @search.hashed('twitter').query[:q].should include('#twitter')
  end
  
  it "should be able to specify the language" do
    @search.lang('en').query[:lang].should == 'en'
  end
  
  it "should be able to specify the number of results per page" do
    @search.per_page(25).query[:rpp].should == 25
  end
  
  it "should be able to specify only returning results greater than an id" do
    @search.since(1234).query[:since_id].should == 1234
  end
  
  it "should be able to specify geo coordinates" do
    @search.geocode('40.757929', '-73.985506', '25mi').query[:geocode].should == '40.757929,-73.985506,25mi'
  end
  
  it "should be able to clear the filters set" do
    @search.from('jnunemaker').to('oaknd1')
    @search.clear.query.should == {:q => []}
  end
  
  it "should be able to chain methods together" do
    @search.from('jnunemaker').to('oaknd1').referencing('orderedlist').containing('milk').hashed('twitter').lang('en').per_page(20).since(1234).geocode('40.757929', '-73.985506', '25mi')
    @search.query[:q].should == ['from:jnunemaker', 'to:oaknd1', '@orderedlist', 'milk', '#twitter']
    @search.query[:lang].should == 'en'
    @search.query[:rpp].should == 20
    @search.query[:since_id].should == 1234
    @search.query[:geocode].should == '40.757929,-73.985506,25mi'
  end
  
  describe "fetching" do
    before do
      @response = open(File.dirname(__FILE__) + '/fixtures/friends_timeline.xml').read
      @search.class.stub!(:get).and_return(@response)
    end
    
    it "should return results" do
      @search.class.should_receive(:get).and_return(@response)
      @search.from('jnunemaker').fetch().should == @response
    end
  end
  
  it "should be able to iterate over results" do
    @search.respond_to?(:each).should == true
  end
end