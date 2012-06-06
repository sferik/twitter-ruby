# The Twitter Ruby Gem [![Build Status](https://secure.travis-ci.org/jnunemaker/twitter.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/jnunemaker/twitter.png?travis)][gemnasium]
A Ruby wrapper for the Twitter API.

[travis]: http://travis-ci.org/jnunemaker/twitter
[gemnasium]: https://gemnasium.com/jnunemaker/twitter

## Installation
    gem install twitter

Looking for the Twitter command-line interface? It was [removed][] from this
gem in version 0.5.0 and now is [maintained][] as a separate project:

    gem install t

[removed]: https://github.com/jnunemaker/twitter/commit/dd2445e3e2c97f38b28a3f32ea902536b3897adf
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

[apps]: https://github.com/jnunemaker/twitter/wiki/apps

## What's new in version 3?

The Active Support dependency has been removed!

The following methods now accept multiple users or ids as arguments and return
arrays:

    Twitter::Client#accept                  Twitter::Client#retweet
    Twitter::Client#block                   Twitter::Client#saved_search
    Twitter::Client#deny                    Twitter::Client#saved_search_destroy
    Twitter::Client#direct_message          Twitter::Client#status
    Twitter::Client#direct_message_destroy  Twitter::Client#status_activity
    Twitter::Client#disable_notifications   Twitter::Client#status_destroy
    Twitter::Client#enable_notifications    Twitter::Client#status_with_activity
    Twitter::Client#favorite                Twitter::Client#unblock
    Twitter::Client#follow                  Twitter::Client#unfavorite
    Twitter::Client#oembed                  Twitter::Client#unfollow
    Twitter::Client#report_spam

Additionally, the `Twitter::Client#follow` method now checks to make sure the
user isn't already being followed. If you don't wish to perform that check
(which does require an extra HTTP request), you can use the new
`Twitter::Client#follow!` method instead. **Note**: This may re-send an email
notification to the user, even if they are already being followed.

This version introduces an identity map, which ensures that the same objects
only get initialized once:

    Twitter.user("sferik").object_id == Twitter.user("sferik").object_id #=> true

(In all previous versions of this gem, this statement would have returned
false.)

The `Twitter::Client#search` now returns a `Twitter::SearchResult` object,
which contains metadata and a results array. In the previous major version,
this method returned an array of `Twitter::Status` objects, which is now
accessible by sending the `results` message to a `Twitter::SearchResults`
object.

    # Version 2
    Twitter::Client.search("query").each do |status|
      puts status.full_text
    end

    # Version 3
    Twitter::Client.search("query").results.each do |status|
      puts status.full_text
    end

The `Twitter::Status#expanded_urls` method has been removed. Use
`Twitter::Status#urls` instead.

This library is now more SOLID! In the previous version, [the `Twitter::Cursor`
class violated the Liskov substitution principle][lsp]. This came back to bite
us when trying to implement the identity map. We regret the error.

[lsp]: https://github.com/jnunemaker/twitter/commit/9e6823b614d1af94089f51400ebd637ca04bab9d

## <a href="performance"></a>Performance
You can improve performance by preloading a faster JSON parsing library. By
default, JSON will be parsed with [okjson][]. For faster JSON parsing, we
recommend [Oj][].

[okjson]: https://github.com/ddollar/okjson
[oj]: https://rubygems.org/gems/oj

## Usage Examples
Return [@sferik][sferik]'s location

    Twitter.user("sferik").location
Return [@sferik][sferik]'s most recent Tweet

    Twitter.user_timeline("sferik").first.text
Return the text of the Tweet at https://twitter.com/sferik/statuses/27558893223

    Twitter.status(27558893223).text
Find the 3 most recent marriage proposals to [@justinbieber][justinbieber]

    Twitter.search("to:justinbieber marry me", :rpp => 3, :result_type => "recent").results.map do |status|
      "#{status.from_user}: #{status.text}"
    end

Let's find a Japanese-language Tweet tagged #ruby (no retweets)

    Twitter.search("#ruby -rt", :lang => "ja", :rpp => 1).results.first.text

The search result object returned by `Twitter::Client#search` includes some metadata about the search
results:

    Twitter.search("to:justinbieber marry me", :rpp => 3, :result_type => "recent").max_id => 28857935752

The `max_id` attribute can be used in your next search query as the `:since_id` parameter to only return newer
tweets.

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

## Configuration for API Proxy Services

    Twitter.gateway = YOUR_GATEWAY_HOSTNAME # e.g 'gateway.example.com'

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

[issues]: https://github.com/jnunemaker/twitter/issues

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
implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* [JRuby][]
* [Rubinius][]

[jruby]: http://www.jruby.org/
[rubinius]: http://rubini.us/

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

## Copyright
Copyright (c) 2011 John Nunemaker, Wynn Netherland, Erik Michaels-Ober, Steve Richert.
See [LICENSE][] for details.

[license]: https://github.com/jnunemaker/twitter/blob/master/LICENSE.md
