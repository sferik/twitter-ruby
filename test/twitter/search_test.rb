require File.dirname(__FILE__) + '/../test_helper'

class SearchTest < Test::Unit::TestCase
  context "searching" do
    setup do
      @search = Twitter::Search.new
    end

    should "should be able to initialize with a search term" do
      Twitter::Search.new('httparty').query[:q].should include('httparty')
    end
    
    should "default user agent to Ruby Twitter Gem" do
      search = Twitter::Search.new('foo')
      search.user_agent.should == 'Ruby Twitter Gem'
    end
    
    should "allow overriding default user agent" do
      search = Twitter::Search.new('foo', :user_agent => 'Foobar')
      search.user_agent.should == 'Foobar'
    end
    
    should "pass user agent along with headers when making request" do
      Twitter::Search.expects(:get).with('http://search.twitter.com/search.json', {:format => :json, :query => {:q => 'foo'}, :headers => {'User-Agent' => 'Foobar'}})
      Twitter::Search.new('foo', :user_agent => 'Foobar').fetch()
    end

    should "should be able to specify from" do
      @search.from('jnunemaker').query[:q].should include('from:jnunemaker')
    end

    should "should be able to specify to" do
      @search.to('jnunemaker').query[:q].should include('to:jnunemaker')
    end

    should "should be able to specify referencing" do
      @search.referencing('jnunemaker').query[:q].should include('@jnunemaker')
    end

    should "should alias references to referencing" do
      @search.references('jnunemaker').query[:q].should include('@jnunemaker')
    end

    should "should alias ref to referencing" do
      @search.ref('jnunemaker').query[:q].should include('@jnunemaker')
    end

    should "should be able to specify containing" do
      @search.containing('milk').query[:q].should include('milk')
    end

    should "should alias contains to containing" do
      @search.contains('milk').query[:q].should include('milk')
    end  

    should "should be able to specify hashed" do
      @search.hashed('twitter').query[:q].should include('#twitter')
    end

    should "should be able to specify the language" do
      @search.lang('en')
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:lang => 'en', :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to specify the number of results per page" do
      @search.per_page(25)
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:rpp => 25, :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to specify the page number" do
      @search.page(20)
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:page => 20, :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to specify only returning results greater than an id" do
      @search.since(1234)
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:since_id => 1234, :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to specify geo coordinates" do
      @search.geocode('40.757929', '-73.985506', '25mi')
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:geocode => '40.757929,-73.985506,25mi', :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to specify max id" do
      @search.max(1234)
      @search.class.expects(:get).with('http://search.twitter.com/search.json', :query => {:max_id => 1234, :q => ''}, :format => :json, :headers => {'User-Agent' => 'Ruby Twitter Gem'}).returns({'foo' => 'bar'})
      @search.fetch()
    end

    should "should be able to clear the filters set" do
      @search.from('jnunemaker').to('oaknd1')
      @search.clear.query.should == {:q => []}
    end

    should "should be able to chain methods together" do
      @search.from('jnunemaker').to('oaknd1').referencing('orderedlist').containing('milk').hashed('twitter').lang('en').per_page(20).since(1234).geocode('40.757929', '-73.985506', '25mi')
      @search.query[:q].should == ['from:jnunemaker', 'to:oaknd1', '@orderedlist', 'milk', '#twitter']
      @search.query[:lang].should == 'en'
      @search.query[:rpp].should == 20
      @search.query[:since_id].should == 1234
      @search.query[:geocode].should == '40.757929,-73.985506,25mi'
    end

    context "fetching" do
      setup do
        stub_get('http://search.twitter.com:80/search.json?q=%40jnunemaker', 'search.json')
        @search = Twitter::Search.new('@jnunemaker')
        @response = @search.fetch
      end

      should "should return results" do
        @response.results.size.should == 15
      end

      should "should support dot notation" do
        first = @response.results.first
        first.text.should == %q(Someone asked about a tweet reader. Easy to do in ruby with @jnunemaker's twitter gem and the win32-sapi gem, if you are on windows.)
        first.from_user.should == 'PatParslow'
      end
      
      should "cache fetched results so multiple fetches don't keep hitting api" do
        Twitter::Search.expects(:get).never
        @search.fetch
      end
      
      should "rehit api if fetch is called with true" do
        Twitter::Search.expects(:get).once
        @search.fetch(true)
      end
    end
    
    context "iterating over results" do
      setup do
        stub_get('http://search.twitter.com:80/search.json?q=from%3Ajnunemaker', 'search_from_jnunemaker.json')
        @search.from('jnunemaker')
      end
      
      should "work" do
        @search.each { |result| result.should_not be(nil) }
      end
      
      should "work multiple times in a row" do
        @search.each { |result| result.should_not be(nil) }
        @search.each { |result| result.should_not be(nil) }
      end
    end
    
    should "should be able to iterate over results" do
      @search.respond_to?(:each).should be(true)
    end
  end
  
end