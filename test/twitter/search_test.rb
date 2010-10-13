require 'test_helper'

class SearchTest < Test::Unit::TestCase

  context "searching" do
    setup do
      Twitter.format = 'json'
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
      assert @search.from('sferik').query[:q].include? 'from:sferik'
    end

    should "specify not from" do
      assert @search.from('sferik', true).query[:q].include? '-from:sferik'
    end

    should "specify to" do
      assert @search.to('sferik').query[:q].include? 'to:sferik'
    end

    should "specify not to" do
      assert @search.to('sferik', true).query[:q].include? '-to:sferik'
    end

    should "specify not referencing" do
      assert @search.referencing('sferik', true).query[:q].include? '-@sferik'
    end

    should "alias references to referencing" do
      assert @search.references('sferik').query[:q].include? '@sferik'
    end

    should "alias ref to referencing" do
      assert @search.ref('sferik').query[:q].include? '@sferik'
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
      assert @search.hashed('twitter', true).query[:q].include? '-#twitter'
    end

    should "specify the language" do
      stub_get('https://search.twitter.com/search.json?q=&lang=en', 'hash.json')
      assert @search.lang('en')
      assert @search.fetch
    end

    should "specify the locale" do
      stub_get('https://search.twitter.com/search.json?q=&locale=ja', 'hash.json')
      assert @search.locale('ja')
      assert @search.fetch
    end

    should "specify the number of results per page" do
      stub_get('https://search.twitter.com/search.json?q=&rpp=25', 'hash.json')
      assert @search.per_page(25)
      assert @search.fetch
    end

    should "specify the page number" do
      stub_get('https://search.twitter.com/search.json?q=&page=20', 'hash.json')
      assert @search.page(20)
      assert @search.fetch
    end

    should "specify only returning results greater than an id" do
      stub_get('https://search.twitter.com/search.json?q=&since_id=1234', 'hash.json')
      assert @search.since(1234)
      assert @search.fetch
    end

    should "specify since a date" do
      stub_get('https://search.twitter.com/search.json?q=&since=2009-04-14', 'hash.json')
      assert @search.since_date('2009-04-14')
      assert @search.fetch
    end

    should "specify until a date" do
      stub_get('https://search.twitter.com/search.json?q=&until=2009-04-14', 'hash.json')
      assert @search.until_date('2009-04-14')
      assert @search.fetch
    end

    should "specify geo coordinates" do
      stub_get('https://search.twitter.com/search.json?q=&geocode=40.757929%2C-73.985506%2C25mi', 'hash.json')
      assert @search.geocode('40.757929', '-73.985506', '25mi')
      assert @search.fetch
    end

    should "specify max id" do
      stub_get('https://search.twitter.com/search.json?q=&max_id=1234', 'hash.json')
      assert @search.max(1234)
      assert @search.fetch
    end

    should "set the phrase" do
      stub_get('https://search.twitter.com/search.json?q=&phrase=Who%20Dat', 'hash.json')
      assert @search.phrase('Who Dat')
      assert @search.fetch
    end

    should "set the result type" do
      stub_get('https://search.twitter.com/search.json?q=&result_type=popular', 'hash.json')
      assert @search.result_type('popular')
      assert @search.fetch
    end

    should "clear the filters set" do
      @search.from('sferik').to('oaknd1')
      assert_equal [], @search.clear.query[:q]
    end

    should "chain methods together" do
      @search.from('sferik').to('oaknd1').referencing('orderedlist').containing('milk').retweeted.hashed('twitter').lang('en').per_page(20).since(1234).geocode('40.757929', '-73.985506', '25mi')
      assert_equal ['from:sferik', 'to:oaknd1', '@orderedlist', 'milk', 'rt', '#twitter'], @search.query[:q]
      assert_equal 'en', @search.query[:lang]
      assert_equal 20, @search.query[:rpp]
      assert_equal 1234, @search.query[:since_id]
      assert_equal '40.757929,-73.985506,25mi', @search.query[:geocode]
    end

    should "not replace the current query when fetching" do
      stub_get('https://search.twitter.com/search.json?q=milk%20cheeze', 'hash.json')
      assert @search.containing('milk').containing('cheeze')
      assert_equal ['milk', 'cheeze'], @search.query[:q]
      assert @search.fetch
      assert_equal ['milk', 'cheeze'], @search.query[:q]
    end

    context "fetching" do
      setup do
        stub_get('https://search.twitter.com/search.json?q=%40sferik', 'hash.json')
        @search = Twitter::Search.new('@sferik')
        @response = @search.fetch
      end

      should "know whether another page is available" do
        assert @search.respond_to?(:next_page?)
      end

      should "be able to fetch the next page" do
        assert @search.respond_to?(:fetch_next_page)
      end
    end

    context "iterating over results" do
      setup do
        stub_get('https://search.twitter.com/search.json?q=from%3Asferik', 'hash.json')
        @search.from('sferik')
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
