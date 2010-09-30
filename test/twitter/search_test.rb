require 'test_helper'

class SearchTest < Test::Unit::TestCase

  context "searching" do
    setup do
      @search = Twitter::Search.new
    end

    should "initialize with a search term" do
      assert Twitter::Search.new('httparty').query[:q].include? 'httparty'
    end

    should "default user agent to Ruby Twitter Gem" do
      search = Twitter::Search.new('foo')
      assert_equal 'Ruby Twitter Gem', search.user_agent
    end

    should "allow overriding default user agent" do
      search = Twitter::Search.new('foo', :user_agent => 'Foobar')
      assert_equal 'Foobar', search.user_agent
    end

    should "specify from" do
      assert @search.from('jnunemaker').query[:q].include? 'from:jnunemaker'
    end

    should "specify not from" do
      assert @search.from('jnunemaker',true).query[:q].include? '-from:jnunemaker'
    end

    should "specify to" do
      assert @search.to('jnunemaker').query[:q].include? 'to:jnunemaker'
    end

    should "specify not to" do
      assert @search.to('jnunemaker',true).query[:q].include? '-to:jnunemaker'
    end

    should "specify not referencing" do
      assert @search.referencing('jnunemaker',true).query[:q].include? '-@jnunemaker'
    end

    should "alias references to referencing" do
      assert @search.references('jnunemaker').query[:q].include? '@jnunemaker'
    end

    should "alias ref to referencing" do
      assert @search.ref('jnunemaker').query[:q].include? '@jnunemaker'
    end

    should "specify containing" do
      assert @search.containing('milk').query[:q].include? 'milk'
    end

    should "specify not containing" do
      assert @search.containing('milk', true).query[:q].include? '-milk'
    end

    should "alias contains to containing" do
      assert @search.contains('milk').query[:q].include? 'milk'
    end

    should "specify retweeted" do
      assert @search.retweeted.query[:q].include? 'rt'
    end

    should "specify not_retweeted" do
      assert @search.not_retweeted.query[:q].include? '-rt'
    end

    should "specify filters" do
      assert @search.filter('links').query[:q].include? 'filter:links'
    end

    should "specify hashed" do
      assert @search.hashed('twitter').query[:q].include? '#twitter'
    end

    should "specify not hashed" do
      assert @search.hashed('twitter',true).query[:q].include? '-#twitter'
    end

    should "specify the language" do
      stub_get('http://search.twitter.com/search.json?q=&lang=en', 'search.json')
      assert @search.lang('en')
      assert @search.fetch
    end

    should "specify the locale" do
      stub_get('http://search.twitter.com/search.json?q=&locale=ja', 'search.json')
      assert @search.locale('ja')
      assert @search.fetch
    end

    should "specify the number of results per page" do
      stub_get('http://search.twitter.com/search.json?q=&rpp=25', 'search.json')
      assert @search.per_page(25)
      assert @search.fetch
    end

    should "specify the page number" do
      stub_get('http://search.twitter.com/search.json?q=&page=20', 'search.json')
      assert @search.page(20)
      assert @search.fetch
    end

    should "specify only returning results greater than an id" do
      stub_get('http://search.twitter.com/search.json?q=&since_id=1234', 'search.json')
      assert @search.since(1234)
      assert @search.fetch
    end

    should "specify since a date" do
      stub_get('http://search.twitter.com/search.json?q=&since=2009-04-14', 'search.json')
      assert @search.since_date('2009-04-14')
      assert @search.fetch
    end

    should "specify until a date" do
      stub_get('http://search.twitter.com/search.json?q=&until=2009-04-14', 'search.json')
      assert @search.until_date('2009-04-14')
      assert @search.fetch
    end

    should "specify geo coordinates" do
      stub_get('http://search.twitter.com/search.json?q=&geocode=40.757929%2C-73.985506%2C25mi', 'search.json')
      assert @search.geocode('40.757929', '-73.985506', '25mi')
      assert @search.fetch
    end

    should "specify max id" do
      stub_get('http://search.twitter.com/search.json?q=&max_id=1234', 'search.json')
      assert @search.max(1234)
      assert @search.fetch
    end

    should "set the phrase" do
      stub_get('http://search.twitter.com/search.json?q=&phrase=Who%20Dat', 'search.json')
      assert @search.phrase('Who Dat')
      assert @search.fetch
    end

    should "set the result type" do
      stub_get('http://search.twitter.com/search.json?q=&result_type=popular', 'search.json')
      assert @search.result_type('popular')
      assert @search.fetch
    end

    should "clear the filters set" do
      @search.from('jnunemaker').to('oaknd1')
      assert_equal [], @search.clear.query[:q]
    end

    should "chain methods together" do
      @search.from('jnunemaker').to('oaknd1').referencing('orderedlist').containing('milk').retweeted.hashed('twitter').lang('en').per_page(20).since(1234).geocode('40.757929', '-73.985506', '25mi')
      assert_equal ['from:jnunemaker', 'to:oaknd1', '@orderedlist', 'milk', 'rt', '#twitter'], @search.query[:q]
      assert_equal 'en', @search.query[:lang]
      assert_equal 20, @search.query[:rpp]
      assert_equal 1234, @search.query[:since_id]
      assert_equal '40.757929,-73.985506,25mi', @search.query[:geocode]
    end

    should "not replace the current query when fetching" do
      stub_get('http://search.twitter.com/search.json?q=milk%20cheeze', 'search_milk_cheeze.json')
      assert @search.containing('milk').containing('cheeze')
      assert_equal ['milk', 'cheeze'], @search.query[:q]
      assert @search.fetch
      assert_equal ['milk', 'cheeze'], @search.query[:q]
    end

    context "fetching" do
      setup do
        stub_get('http://search.twitter.com/search.json?q=%40jnunemaker', 'search.json')
        @search = Twitter::Search.new('@jnunemaker')
        @response = @search.fetch
      end

      should "return results" do
        assert_equal 15, @response.results.size
      end

      should "support dot notation" do
        first = @response.results.first
        assert_equal %q(Someone asked about a tweet reader. Easy to do in ruby with @jnunemaker's twitter gem and the win32-sapi gem, if you are on windows.), first.text
        assert_equal 'PatParslow', first.from_user
      end

      should "tell if another page is available" do
        assert @search.next_page?
      end

      should "fetch the next page" do
        stub_get('http://search.twitter.com/search.json?page%3D2%26max_id%3D1446791544%26q%3D%2540jnunemaker=', 'search.json')
        @search.fetch_next_page
      end
    end

    context "iterating over results" do
      setup do
        stub_get('http://search.twitter.com/search.json?q=from%3Ajnunemaker', 'search_from_jnunemaker.json')
        @search.from('jnunemaker')
      end

      should "work" do
        @search.each { |result| assert result }
      end

      should "work multiple times in a row" do
        @search.each { |result| assert result }
        @search.each { |result| assert result }
      end
    end

    should "iterate over results" do
      assert_respond_to @search, :each
    end
  end

end
