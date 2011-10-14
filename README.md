# The Twitter Ruby Gem
A Ruby wrapper for the Twitter API.

## <a name="installation"></a>Installation
    gem install twitter

## <a name="documentation"></a>Documentation
[http://rdoc.info/gems/twitter][documentation]

[documentation]: http://rdoc.info/gems/twitter

## <a name="follow"></a>Follow @gem on Twitter
You should [follow @gem][follow] on Twitter for announcements and updates about
the gem.

[follow]: https://twitter.com/gem

## <a name="mailing_list"></a>Mailing List
Please direct any questions about the library to the [mailing list].

[mailing list]: https://groups.google.com/group/ruby-twitter-gem

## <a name="apps"></a>Apps Wiki
Does your project or organization use this gem? Add it to the [apps
wiki][apps]!

[apps]: https://github.com/jnunemaker/twitter/wiki/apps

## <a name="ci"></a>Continuous Integration
[![Build Status](https://secure.travis-ci.org/jnunemaker/twitter.png)][ci]

[ci]: http://travis-ci.org/jnunemaker/twitter

## <a name="2.0"></a>What new in version 2?
This version introduces 15 new classes:

1. `Twitter::Cursor`
2. `Twitter::DirectMessage`
3. `Twitter::Language`
4. `Twitter::List`
5. `Twitter::Photo`
6. `Twitter::Place`
7. `Twitter::Point`
8. `Twitter::Polygon`
9. `Twitter::RateLimitStatus`
10. `Twitter::Relationship`
11. `Twitter::SavedSearch`
12. `Twitter::Settings`
13. `Twitter::Size`
14. `Twitter::Status`
15. `Twitter::User`

These classes (plus Ruby primitives) have replaced all instances of
`Hashie::Mash`. This allows us to remove the gem's dependency on [hashie][] and
eliminate a layer in the middleware stack.

[hashie]: https://github.com/intridea/hashie

This should have the effect of making object instantiation and method
invocation faster and less susceptible to typos. For example, if you typed
`Twitter.user("sferik").loctaion`, a `Hashie::Mash` would return `nil` instead
of raising a `NoMethodError`.

Another benefit of these new objects is instance methods like `created_at` now
return a `Time` instead of a `String`. This should make the objects easier to
work with and better fulfills the promise of this library as a Ruby wrapper for
the Twitter API.

Any instance method that returns a boolean can now be called with a trailing
question mark, for example:

    Twitter.user("sferik").protected?

Version 2 also includes some advanced Tweet-parsing methods, for example:

    # Fetch the Tweet at https://twitter.com/twitter/statuses/76360760606986241
    status = Twitter.status(76360760606986241)

    # Return all hashtags in the Tweet
    status.hashtags #=> ["Photos"]

    # Return all URLs in the Tweet
    status.urls #=> ["http://t.co/qbJx26r"]

    # Return all users mentioned in the Tweet
    status.user_mentions #=> []

Tweet parsing is performed by [twitter-text][], Twitter's official text
processing library, so it should be consistent with all other Twitter services.

[twitter-text]: https://github.com/twitter/twitter-text-rb

This version also introduces object equivalence, so objects that are logically
equivalent are considered equal, even if they don't occupy the same address in
memory, for example:

    Twitter.user("sferik") == Twitter.user("sferik") #=> true
    Twitter.user("sferik") == Twitter.user(7505382) #=> true

In previous versions of this gem, both of the above statements would have
returned false. We've stopped short of implementing a true identity map, such
that:

    Twitter.user("sferik").object_id == Twitter.user("sferik").object_id

I wouldn't mind seeing this feature implemented in a future version of the gem,
but object equivalence seems like a step in the right direction.

### Additional Notes
* All deprecated methods have been removed.
* `Twitter::Client#totals` has been removed. Use `Twitter::Client#user`
  instead.
* `Twitter::Client#friendships` now takes up to 3 arguments instead of 1.
* Support for the XML response format has been removed. This decision was
  guided largely by Twitter, who has started removing XML responses available
  for [some resources][trends]. This allows us to remove the gem's dependency
  on [multi_xml][]. Using JSON is faster than XML, both in terms of parsing
  speed and time over the wire.
* All error classes have been moved inside the `Twitter::Error` namespace. If
  you were previously rescuing `Twitter::NotFound` you'll need to change that
  to `Twitter::Error::NotFound`.

[trends]: https://dev.twitter.com/blog/changing-trends-api
[multi_xml]: https://github.com/sferik/multi_xml

## <a href="performance"></a>Performance
You can improve performance by preloading a faster JSON parsing library. By
default, JSON will be parsed with [okjson][]. For faster JSON parsing, we
recommend [yajl][].

[okjson]: https://github.com/ddollar/okjson
[yajl]: https://github.com/brianmario/yajl-ruby

## <a name="examples"></a>Usage Examples
Return [@sferik][sferik]'s location

    Twitter.user("sferik").location
Return [@sferik][sferik]'s most recent Tweet

    Twitter.user_timeline("sferik").first.text
Return the text of the Tweet at https://twitter.com/sferik/statuses/27558893223

    Twitter.status(27558893223).text
Find the 3 most recent marriage proposals to [@justinbieber][justinbieber]

    search = Twitter::Search.new
    search.containing("marry me").to("justinbieber").result_type("recent").per_page(3).map do |status|
      "#{status["from_user"]}: #{status["text"]}"
    end
Enough about Justin Bieber. Let's find a Japanese-language Tweet tagged #ruby.

    search = Twitter::Search.new
    search.hashtag("ruby").language("ja").no_retweets.per_page(1).fetch.first["text"]

Certain methods require authentication. To get your Twitter OAuth credentials,
register an app at http://dev.twitter.com/apps

    Twitter.configure do |config|
      config.consumer_key = YOUR_CONSUMER_KEY
      config.consumer_secret = YOUR_CONSUMER_SECRET
      config.oauth_token = YOUR_OAUTH_TOKEN
      config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
    end
Update your status

    Twitter.update("I'm tweeting with @gem!")
Read the most recent Tweet in your timeline

    Twitter.home_timeline.first.text
Get your rate limit status

    Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"

[sferik]: https://twitter.com/sferik
[justinbieber]: https://twitter.com/justinbieber

## <a name="proxy"></a>Configuration for API Proxy Services
Use of API proxy services, like [Apigee](http://apigee.com), can be used to
attain higher rate limits to the Twitter API.

    Twitter.gateway = YOUR_GATEWAY_HOSTNAME # e.g 'twitter.apigee.com'

## <a name="contributing"></a>Contributing
In the spirit of [free software][], **everyone** is encouraged to help improve
this project.

[free software]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by closing [issues][]
* by reviewing patches
* [financially][]

[issues]: https://github.com/jnunemaker/twitter/issues
[financially]: http://pledgie.com/campaigns/1193

All contributors will be added to the [history][] and will receive the respect
and gratitude of the community.

[history]: https://github.com/jnunemaker/twitter/blob/master/HISTORY.md

## <a name="issues"></a>Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. You can indicate support for an existing issuse by
voting it up. When submitting a bug report, please include a [gist][] that
includes a stack trace and any details that may be necessary to reproduce the
bug, including your gem version, Ruby version, and operating system. Ideally, a
bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## <a name="pulls"></a>Submitting a Pull Request
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>bundle exec rake doc:yard</tt>. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>bundle exec rake spec</tt>. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)

## <a name="rubies"></a>Supported Rubies
This library aims to support and is [tested against][ci] the following Ruby
implementations:

* Ruby 1.8.7
* Ruby 1.9.1
* Ruby 1.9.2
* [JRuby][]
* [Rubinius][]
* [Ruby Enterprise Edition][ree]

[jruby]: http://www.jruby.org/
[rubinius]: http://rubini.us/
[ree]: http://www.rubyenterpriseedition.com/

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## <a name="copyright"></a>Copyright
Copyright (c) 2011 John Nunemaker, Wynn Netherland, Erik Michaels-Ober, Steve Richert.
See [LICENSE][] for details.

[license]: https://github.com/jnunemaker/twitter/blob/master/LICENSE.md
