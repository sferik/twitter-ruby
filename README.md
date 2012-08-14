# The Twitter Ruby Gem [![Build Status](https://secure.travis-ci.org/sferik/twitter.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/sferik/twitter.png?travis)][gemnasium] [![Code Climate](https://codeclimate.com/badge.png)][codeclimate]
A Ruby wrapper for the Twitter API.

[travis]: http://travis-ci.org/sferik/twitter
[gemnasium]: https://gemnasium.com/sferik/twitter
[codeclimate]: https://codeclimate.com/github/sferik/twitter

## Installation
    gem install twitter

Looking for the Twitter command-line interface? It was [removed][] from this
gem in version 0.5.0 and now is [maintained][] as a separate project:

    gem install t

[removed]: https://github.com/sferik/twitter/commit/dd2445e3e2c97f38b28a3f32ea902536b3897adf
[maintained]: https://github.com/sferik/t

## Documentation
[http://rdoc.info/gems/twitter][documentation]

[documentation]: http://rdoc.info/gems/twitter

## Follow @gem on Twitter
You should [follow @gem][follow] on Twitter for announcements and updates about
this library.

[follow]: https://twitter.com/gem

## Mailing List
Please direct questions about the library to the [mailing list].

[mailing list]: https://groups.google.com/group/ruby-twitter-gem

## Apps Wiki
Does your project or organization use this gem? Add it to the [apps
wiki][apps]!

[apps]: https://github.com/sferik/twitter/wiki/apps

## What's new in version 3?
### Hashes
All returned hashes now use symbols as keys instead of strings.

### Methods
The following methods now accept multiple users or ids as arguments and return
arrays:

    Twitter::Client#accept                  Twitter::Client#enable_notifications    Twitter::Client#saved_search_destroy
    Twitter::Client#block                   Twitter::Client#favorite                Twitter::Client#status_destroy
    Twitter::Client#deny                    Twitter::Client#follow                  Twitter::Client#unblock
    Twitter::Client#direct_message_destroy  Twitter::Client#report_spam             Twitter::Client#unfavorite
    Twitter::Client#disable_notifications   Twitter::Client#retweet                 Twitter::Client#unfollow

Whenever more than one user or id is passed to any of these methods, HTTP
requests are made in parallel using multiple threads, resulting in dramatically
better performance than calling these methods multiple times in serial.

The `Twitter::Client#direct_messages` method has been renamed to
`Twitter::Client#direct_messages_received`.

The `Twitter::Client#profile_image` method has been removed. Use
`Twitter::User#profile_image_url` (or `Twitter::User#profile_image_url_https`)
instead.

The `Twitter::Status#expanded_urls` method has been removed. Use
`Twitter::Status#urls` instead.

The `Twitter::Client#follow` method now checks to make sure the user isn't
already being followed. If you don't wish to perform that check (which does
require an extra HTTP request), you can use the new `Twitter::Client#follow!`
method instead. **Note**: This may re-send an email notification to the user,
even if they are already being followed.

The `Twitter::Client#search` method now returns a `Twitter::SearchResult`
object, which contains metadata and a results array. In the previous major
version, this method returned an array of `Twitter::Status` objects, which is
now accessible by sending the `results` message to a `Twitter::SearchResults`
object.

##### Version 2
    Twitter::Client.search("query").map(&:full_text)

##### Version 3
    Twitter::Client.search("query").results.map(&:full_text)

### Configuration
The Faraday middleware stack is now fully configurable and is exposed as a
`Faraday::Builder`. You can modify the default middleware in-place:

    Twitter.middleware.insert_after Twitter::Response::RaiseClientError, CustomMiddleware

You can no longer set a custom adapter via `Twitter::Config#adapter=`, however a
custom adapter may be set as part of a custom middleware stack:

    Twitter.middleware = Faraday::Builder.new(
      &Proc.new do |builder|
        # Specify a middleware stack here
        builder.adapter :some_other_adapter
      end
    )

Support for API gateways via `gateway` configuration has removed. This
functionality may be replicated by inserting custom Faraday middleware.

The `Twitter::Conif#proxy=` and `Twitter::Config#user_agent=` setters have also
been removed. These options can be set by modifying the default connection
options:

    Twitter.connection_options[:proxy] = 'http://erik:sekret@proxy.example.com:8080'
    Twitter.connection_options[:headers][:user_agent] = 'Custom User Agent'

### Authentication
Configure a threadsafe Twitter client:

    Twitter.configure do |config|
      config.consumer_key = YOUR_CONSUMER_KEY
      config.consumer_secret = YOUR_SECRET_KEY
    end

    twitter_client = Twitter.client(:oauth_token => OAUTH_TOKEN_FOR_USER, :oauth_token_secret => OAUTH_SECRET_FOR_USER)

If not supplied, this library pulls credentials from environment variables:

    TWITTER_CONSUMER_KEY
    TWITTER_CONSUMER_SECRET
    TWITTER_OAUTH_TOKEN
    TWITTER_OAUTH_TOKEN_SECRET

### Identity Map
This version introduces an identity map, which ensures that the same objects
only get initialized once:

    twitter_client.user("sferik").object_id == twitter_client.user("sferik").object_id #=> true

(In all previous versions of this gem, this statement would have returned
false.)

### Errors
Any Faraday client errors are captured and re-raised as a
`Twitter::Error::ClientError`, so there's no longer a need to separately rescue
`Faraday::Error::ClientError`.

All `Twitter::Error` rate limit methods (including `Twitter::Error.retry_at`)
have been replaced by the `Twitter::Error#rate_limit` method, which returns a
`Twitter::RateLimit` instance. Likewise, there is now a
`Twitter::Client#rate_limit` method, which gets updated after each request.

    twitter_client.user("sferik") # Any API request will fetch rate limit information
    rate_limit = twitter_client.rate_limit
    rate_limit.limit     #=> 150
    rate_limit.remaining #=> 149
    rate_limit.reset_at  #=> 2012-07-16 12:34:56 -0700
    rate_limit.reset_in  #=> 3540 (seconds)

### Additional notes
This will be the last major version of this library to support Ruby 1.8.
Requiring Ruby 1.9 will allow us to [remove][class_variable_get]
[various][each_with_object] [hacks][singleton_class] put in place to maintain
Ruby 1.8 compatibility. [The first stable version of Ruby 1.9 was released on
August 19, 2010.][ruby192] If you haven't found the opportunity to upgrade your
Ruby interpreter since then, let this be your nudge. Once version 4 of this
library is released, all previous versions will cease to be supported, even if
critical security vulnerabilities are discovered.

[class_variable_get]: https://github.com/sferik/twitter/commit/88c5a0513d1b58a1d4ae1a1e3deeb012c9d19547
[each_with_object]: https://github.com/sferik/twitter/commit/6052252a07baf7aefe0f100bba0abd2cbb7139bb
[singleton_class]: https://github.com/sferik/twitter/commit/2ed9db21c87d1218b15373e42a36ad536b07dcbb
[ruby192]: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/367983

Here are some fun facts about the 3.0 release:

* The entire library is implemented in just 2,000 lines of code
* With over 5,000 lines of specs, the spec-to-code ratio is over 2.5:1
* The spec suite contains 674 examples and runs in under 2 seconds on a MacBook
* This project has 100% C0 code coverage (the tests execute every line of
  source code at least once)
* At the time of release, this library is comprehensive: you can request all
  documented Twitter REST API resources that respond with JSON (over 100)
* This is the first multithreaded release (requests are made in parallel)
* This gem works on every major Ruby implementation, including JRuby and
  Rubinius
* The first version was released on November 26, 2006 (over 5 years ago)
* This gem has only three dependencies: `faraday`, `multi_json`, and
  `simple_oauth`
* Previous versions of this gem have been [downloaded over half a million
  times][stats]

[stats]: http://rubygems.org/gems/twitter/stats

## Performance
You can improve performance by preloading a faster JSON parsing library. By
default, JSON will be parsed with [okjson][]. For faster JSON parsing, we
recommend [Oj][].

[okjson]: https://github.com/ddollar/okjson
[oj]: https://rubygems.org/gems/oj

## Usage Examples

Return [@sferik][sferik]'s location

    twitter_client.user("sferik").location
Return [@sferik][sferik]'s most recent Tweet

    twitter_client.user_timeline("sferik").first.text
Return the text of the Tweet at https://twitter.com/sferik/statuses/27558893223

    twitter_client.status(27558893223).text
Find the 3 most recent marriage proposals to [@justinbieber][justinbieber]

    twitter_client.search("to:justinbieber marry me", :rpp => 3, :result_type => "recent").results.map do |status|
      "#{status.from_user}: #{status.text}"
    end

Let's find a Japanese-language Tweet tagged #ruby (no retweets)

    twitter_client.search("#ruby -rt", :lang => "ja", :rpp => 1).results.first.text

Certain methods require authentication. To get your Twitter OAuth credentials,
register an app at http://dev.twitter.com/apps

Update your status

    twitter_client.update("I'm tweeting with @gem!")
Read the most recent Tweet in your timeline

    twitter_client.home_timeline.first.text
Get your rate limit status

    rate_limit_status = twitter_client.rate_limit_status
    "#{rate_limit_status.remaining_hits} Twitter API request(s) remaining for the next #{((rate_limit_status.reset_time - Time.now) / 60).floor} minutes and #{((rate_limit_status.reset_time - Time.now) % 60).round} seconds"

[sferik]: https://twitter.com/sferik
[justinbieber]: https://twitter.com/justinbieber

## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by fixing [issues][]
* by reviewing patches

[issues]: https://github.com/sferik/twitter/issues

## Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Run `bundle exec rake yard`. If your changes are not 100% documented, go
   back to step 8.
10. Add, commit, and push your changes.
11. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
version:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2006-2012 John Nunemaker, Wynn Netherland, Erik Michaels-Ober, Steve Richert.
See [LICENSE][] for details.

[license]: https://github.com/sferik/twitter/blob/master/LICENSE.md
