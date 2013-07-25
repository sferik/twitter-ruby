# The Twitter Ruby Gem

[![Gem Version](https://badge.fury.io/rb/twitter.png)][gem]
[![Build Status](https://secure.travis-ci.org/sferik/twitter.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/sferik/twitter.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/sferik/twitter.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/sferik/twitter/badge.png?branch=master)][coveralls]
[![Click here to make a donation](http://www.pledgie.com/campaigns/18388.png)][pledgie]

[gem]: https://rubygems.org/gems/twitter
[travis]: http://travis-ci.org/sferik/twitter
[gemnasium]: https://gemnasium.com/sferik/twitter
[codeclimate]: https://codeclimate.com/github/sferik/twitter
[coveralls]: https://coveralls.io/r/sferik/twitter
[pledgie]: http://pledgie.com/campaigns/18388

A Ruby interface to the Twitter API.

## Installation
    gem install twitter

To ensure the code you're installing hasn't been tampered with, it's
recommended that you verify the signature. To do this, you need to add my
public key as a trusted certificate (you only need to do this once):

    gem cert --add <(curl -Ls https://raw.github.com/sferik/twitter/master/certs/sferik.pem)

Then, install the gem with the high security trust policy:

    gem install twitter -P HighSecurity

## Quick Start Guide
So you want to get up and tweeting as fast as possible?

First, [register your application with Twitter][register].

Then, copy and paste in your OAuth data.

```ruby
Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end
```

That's it! You're ready to Tweet:
```ruby
Twitter.update("I'm tweeting with @gem!")
```

For more examples of how to use the gem, read the [documentation][] or see [Usage Examples][] below.

[register]: https://dev.twitter.com/apps/new
[Usage Examples]: #usage-examples

## CLI

Looking for the Twitter command-line interface? It was [removed][] from this
gem in version 0.5.0 and now exists as a [separate project][t].

[removed]: https://github.com/sferik/twitter/commit/dd2445e3e2c97f38b28a3f32ea902536b3897adf
[t]: https://github.com/sferik/t

## Documentation
[http://rdoc.info/gems/twitter][documentation]

[documentation]: http://rdoc.info/gems/twitter

## Announcements
You should [follow @gem][follow] on Twitter for announcements and updates about
this library.

[follow]: https://twitter.com/gem

## Mailing List
Please direct questions about this library to the [mailing list].

[mailing list]: https://groups.google.com/group/twitter-ruby-gem

## Apps Wiki
Does your project or organization use this gem? Add it to the [apps
wiki][apps]!

[apps]: https://github.com/sferik/twitter/wiki/apps

## What's New in Version 5?
### Cursors
The `Twitter::Cursor` class has been completely redesigned with a focus on
simplicity and performance.

[cursors]: https://dev.twitter.com/docs/misc/cursoring

<table>
  <thead>
    <tr>
      <th>Notes</th>
      <th colspan="2">Version 4</th>
      <th colspan="2">Version 5</th>
    </th>
    <tr>
      <th></th>
      <th>Code</th>
      <th>HTTP GETs</th>
      <th>Code</th>
      <th>HTTP GETs</th>
    </th>
  </thead>
  <tbody>
    <tr>
      <td>
        Are you at the start of the cursor?
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.first</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.first?</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
    <tr>
      <td>
        Return your most recent follower.
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.users.first</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.first</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
    <tr>
      <td>
        Return an array of all your friends.
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.all</code></pre>
      </td>
      <td>
        <em>Θ(n+1)</em>
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.to_a</code></pre>
      </td>
      <td>
        <em>Θ(n)</em>
      </td>
    </tr>
    <tr>
      <td>
        Collect your 20 most recent friends.
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.take(20)</code></pre>
      </td>
      <td>
        <em>Θ(n+1)</em>
      </td>
      <td>
        <pre><code lang="ruby">Twitter.friends.take(20)</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
    <tr>
      <td>
        Collect your 20 most recent friends (twice).
      </td>
      <td>
        <pre><code lang="ruby">2.times.collect do
  Twitter.friends.take(20)
end</code></pre>
      </td>
      <td>
        <em>Θ(2n+2)</em>
      </td>
      <td>
        <pre><code lang="ruby">2.times.collect do
  Twitter.friends.take(20)
end</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
  </tbody>
</table>

In the examples above, *n* is dependent on the number of people the
authenticated user follows on Twitter (divided by 20, the number of friends you
can fetch per request). So, if the user followers 85 people, calling
`Twitter.friends.take(20)` would make 6 HTTP requests in version 4. In version
5, it makes just 1 HTTP request. Keep in mind, eliminating a single HTTP
request to the Twitter API will reduce the latency of your application by
[about 500 ms][status].

[status]: https://dev.twitter.com/status

The last example might seem contrived ("Why would I need to call
`Twitter.friends.take(20)` twice?") but it applies to any
[`Enumerable`][enumerable] method you might call on a cursor, including:
`#all?`, `#collect`, `#count`, `#each`, `#inject`, `#max`, `#min`, `#reject`,
`#reverse_each`, `#select`, `#sort`, `#sort_by`, and `#to_a`. In version 4,
each time you called one of those methods, it would perform *n+1* HTTP
requests. In version 5, it only will perform those HTTP requests the first time
one of those methods is called. Each subsequent call fetches data from a
[cache][].

[enumerable]: http://ruby-doc.org/core-2.0/Enumerable.html
[cache]: https://github.com/sferik/twitter/commit/7d8b2727af9400643ac397207185fd54e3f6387b

The performance improvements are actually even **better** than the table above
indicates. In version 5, calling `Twitter::Cursor#each` (or any
[`Enumerable`][enumerable] method) starts yielding results immediately and
continues yielding as each response comes back from the server. In version 4,
`#each` made a series of requests and waited for the last one to complete
before yielding any data.

Here is a list of the interface changes to `Twitter::Cursor`:

* `#first` has been replaced by `#first?`.
* `#first` now returns the first element in the collection, as perscribed by `Enumerable`.
* `#last` has been replaced by `#last?`.
* `#all` has been replaced by `#to_a`.
* `#collection` and its aliases have been removed.

## Configuration
Twitter API v1.1 requires you to authenticate via OAuth, so you'll need to
[register your application with Twitter][register]. Once you've registered an
application, make sure to set the correct access level, otherwise you may see
the error:

    Read-only application cannot POST

Your new application will be assigned a consumer key/secret pair and you will
be assigned an OAuth access token/secret pair for that application. You'll need
to configure these values before you make a request or else you'll get the
error:

    Bad Authentication data

Applications that make requests on behalf of a single Twitter user can pass
global configuration options as a block to the `Twitter.configure` method.

```ruby
Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end
```

Alternately, you can set the following environment variables:

    TWITTER_CONSUMER_KEY
    TWITTER_CONSUMER_SECRET
    TWITTER_OAUTH_TOKEN
    TWITTER_OAUTH_TOKEN_SECRET

After configuration, requests can be made like so:

```ruby
Twitter.update("I'm tweeting with @gem!")
```

### Thread Safety
Applications that make requests on behalf of multiple Twitter users should
avoid using global configuration. In this case, you may still specify the
`consumer_key` and `consumer_secret` globally. (In a Rails application, this
could go in `config/initializers/twitter.rb`.)

```ruby
Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
end
```

Then, for each user's access token/secret pair, instantiate a
`Twitter::Client`:

```ruby
erik = Twitter::Client.new(
  :oauth_token => "Erik's access token",
  :oauth_token_secret => "Erik's access secret"
)

john = Twitter::Client.new(
  :oauth_token => "John's access token",
  :oauth_token_secret => "John's access secret"
)
```

You can now make threadsafe requests as the authenticated user:

```ruby
Thread.new{erik.update("Tweeting as Erik!")}
Thread.new{john.update("Tweeting as John!")}
```

Or, if you prefer, you can specify all configuration options when instantiating
a `Twitter::Client`:

```ruby
client = Twitter::Client.new(
  :consumer_key => "an application's consumer key",
  :consumer_secret => "an application's consumer secret",
  :oauth_token => "a user's access token",
  :oauth_token_secret => "a user's access secret"
)
```

This may be useful if you're using multiple consumer key/secret pairs.

### Middleware
The Faraday middleware stack is fully configurable and is exposed as a
`Faraday::Builder` object. You can modify the default middleware in-place:

```ruby
Twitter.middleware.insert_after Twitter::Response::RaiseError, CustomMiddleware
```

A custom adapter may be set as part of a custom middleware stack:

```ruby
Twitter.middleware = Faraday::Builder.new(
  &Proc.new do |builder|
    # Specify a middleware stack here
    builder.adapter :some_other_adapter
  end
)
```

## Usage Examples
All examples require an authenticated Twitter client. See the section on <a
href="#configuration">configuration</a> above.

**Tweet (as the authenticated user)**

```ruby
Twitter.update("I'm tweeting with @gem!")
```
**Follow a user (by screen name or user ID)**

```ruby
Twitter.follow("gem")
Twitter.follow(213747670)
```
**Fetch a user (by screen name or user ID)**

```ruby
Twitter.user("gem")
Twitter.user(213747670)
```
**Fetch a cursored list of followers with profile details (by screen name or user ID, or by implict authenticated user)**

```ruby
Twitter.followers("gem")
Twitter.followers(213747670)
Twitter.followers
```
**Fetch a cursored list of friends with profile details (by screen name or user ID, or by implict authenticated user)**

```ruby
Twitter.friends("gem")
Twitter.friends(213747670)
Twitter.friends
```

**Fetch a collection of user_ids that the currently authenticated user does not want to receive retweets from**

```ruby
Twitter.no_retweet_ids
````

**Fetch the timeline of Tweets by a user**

```ruby
Twitter.user_timeline("gem")
Twitter.user_timeline(213747670)
```
**Fetch the timeline of Tweets from the authenticated user's home page**

```ruby
Twitter.home_timeline
```
**Fetch the timeline of Tweets mentioning the authenticated user**

```ruby
Twitter.mentions_timeline
```
**Fetch a particular Tweet by ID**

```ruby
Twitter.status(27558893223)
```
**Collect the 3 most recent marriage proposals to @justinbieber**

```ruby
Twitter.search("to:justinbieber marry me", :count => 3, :result_type => "recent").results.collect do |status|
  "#{status.from_user}: #{status.text}"
end
```
**Find a Japanese-language Tweet tagged #ruby (excluding retweets)**

```ruby
Twitter.search("#ruby -rt", :lang => "ja", :count => 1).results.first.text
```
For more usage examples, please see the full [documentation][].

## Streaming
To access the Twitter Streaming API, we recommend [TweetStream][].

[tweetstream]: https://github.com/intridea/tweetstream

## Performance
You can improve performance by loading a faster JSON parsing library. By
default, JSON will be parsed with [okjson][]. For faster JSON parsing, we
recommend [Oj][].

[okjson]: https://github.com/ddollar/okjson
[oj]: https://rubygems.org/gems/oj

## Statistics
Here are some fun facts about this library:

* It is implemented in just 2,000 lines of Ruby code
* With over 5,000 lines of specs, the spec-to-code ratio is about 2.5:1
* The spec suite contains over 750 examples and runs in about 5 seconds
* It has 100% C0 code coverage (the tests execute every line of
  source code at least once)
* It is comprehensive: you can request all documented Twitter REST API
  resources (over 100 resources)
* This gem works on every major Ruby implementation, including JRuby and
  Rubinius
* The first version was released on November 26, 2006
* This gem has just two runtime dependencies: `faraday`, and `simple_oauth`
* Previous versions of this gem have been [downloaded over half a million
  times][stats]

[stats]: https://rubygems.org/gems/twitter

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

If something doesn't work on one of these interpreters, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

## Versioning
This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'twitter', '~> 4.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Copyright
Copyright (c) 2006-2013 Erik Michaels-Ober, John Nunemaker, Wynn Netherland, Steve Richert, Steve Agalloco.
See [LICENSE][] for details.

[license]: LICENSE.md
