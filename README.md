# The Twitter Ruby Gem

[![Gem Version](http://img.shields.io/gem/v/twitter.svg)][gem]
[![Build Status](http://img.shields.io/travis/sferik/twitter.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/sferik/twitter.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/sferik/twitter.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/sferik/twitter.svg)][coveralls]
[![Inline docs](http://inch-ci.org/github/sferik/twitter.svg?style=shields)][inchpages]

[gem]: https://rubygems.org/gems/twitter
[travis]: https://travis-ci.org/sferik/twitter
[gemnasium]: https://gemnasium.com/sferik/twitter
[codeclimate]: https://codeclimate.com/github/sferik/twitter
[coveralls]: https://coveralls.io/r/sferik/twitter
[inchpages]: http://inch-ci.org/github/sferik/twitter

A Ruby interface to the Twitter API.

## Installation
    gem install twitter

## CLI

Looking for the Twitter command-line interface? It was [removed][] from this
gem in version 0.5.0 and now exists as a [separate project][t].

[removed]: https://github.com/sferik/twitter/commit/dd2445e3e2c97f38b28a3f32ea902536b3897adf
[t]: https://github.com/sferik/t

## Documentation
[http://rdoc.info/gems/twitter][documentation]

[documentation]: http://rdoc.info/gems/twitter

## Examples
[https://github.com/sferik/twitter/tree/master/examples][examples]

[examples]: https://github.com/sferik/twitter/tree/master/examples

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
### Configuration
Global configuration has been removed, as it was not threadsafe. Instead, you
can configure a `Twitter::REST::Client` by passing it a block when it's
initialized.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

Note: `oauth_token` has been renamed to `access_token` and `oauth_token_secret`
is now `access_token_secret` to conform to the terminology used in Twitter's
developer documentation.

### Streaming (Experimental)
This library now offers support for the [Twitter Streaming API][streaming].

[streaming]: https://dev.twitter.com/streaming/overview
[tweetstream]: http://rubygems.org/gems/tweetstream

Site Streams are restricted to whitelisted accounts. To apply for access,
[follow the steps in the Site Streams documentation][site-streams]. [User
Streams][user-streams] do not require prior approval.

[site-streams]: https://dev.twitter.com/streaming/sitestreams#applyingforaccess
[user-streams]: https://dev.twitter.com/streaming/userstreams

Unlike the rest of this library, this feature is not well tested and not
recommended for production applications. I've decided to ship it as an
experimental feature and make it more robust over time. Patches in this area are
particularly welcome.

Hopefully, by the time version 6 is released, this gem can fully replace
[TweetStream][], [em-twitter][], [twitterstream][], and [twitter-stream].
Special thanks to [Steve Agalloco][spagalloco], [Tim Carey-Smith][halorgium],
and [Tony Arcieri][tarcieri] for helping to develop this feature.

[em-twitter]: http://rubygems.org/gems/em-twitter
[twitterstream]: http://rubygems.org/gems/twitterstream
[twitter-stream]: http://rubygems.org/gems/twitter-stream
[spagalloco]: https://github.com/spagalloco
[halorgium]: https://github.com/halorgium
[tarcieri]: https://github.com/tarcieri

**Configuration works just like `Twitter::REST::Client`**

```ruby
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

**Stream mentions of coffee or tea**

```ruby
topics = ["coffee", "tea"]
client.filter(:track => topics.join(",")) do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end
```

**Stream a random sample of all tweets**

```ruby
client.sample do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end
```

**Stream tweets, events, and direct messages for the authenticated user**

```ruby
client.user do |object|
  case object
  when Twitter::Tweet
    puts "It's a tweet!"
  when Twitter::DirectMessage
    puts "It's a direct message!"
  when Twitter::Streaming::StallWarning
    warn "Falling behind!"
  end
end
```

An `object` may be one of the following:
* `Twitter::DirectMessage`
* `Twitter::Streaming::DeletedTweet`
* `Twitter::Streaming::Event`
* `Twitter::Streaming::FriendList`
* `Twitter::Streaming::StallWarning`
* `Twitter::Tweet`

### Cursors
The `Twitter::Cursor` class has been completely redesigned with a focus on
simplicity and performance.

<table>
  <thead>
    <tr>
      <th>Notes</th>
      <th colspan="2">Version 4</th>
      <th colspan="2">Version 5</th>
    </tr>
    <tr>
      <th></th>
      <th>Code</th>
      <th>HTTP GETs</th>
      <th>Code</th>
      <th>HTTP GETs</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        Are you at the start of the cursor?
      </td>
      <td>
        <pre><code>client.friends.first</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
      <td>
        <pre><code>client.friends.first?</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
    <tr>
      <td>
        Return your most recent friend.
      </td>
      <td>
        <pre><code>client.friends.users.first</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
      <td>
        <pre><code>client.friends.first</code></pre>
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
        <pre><code>client.friends.all</code></pre>
      </td>
      <td>
        <em>Θ(n+1)</em>
      </td>
      <td>
        <pre><code>client.friends.to_a</code></pre>
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
        <pre><code>client.friends.take(20)</code></pre>
      </td>
      <td>
        <em>Θ(n+1)</em>
      </td>
      <td>
        <pre><code>client.friends.take(20)</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
    <tr>
      <td>
        Collect your 20 most recent friends twice.
      </td>
      <td>
        <pre><code>friends = client.friends
2.times.collect do
  friends.take(20)
end</code></pre>
      </td>
      <td>
        <em>Θ(2n+2)</em>
      </td>
      <td>
        <pre><code>friends = client.friends
2.times.collect do
  friends.take(20)
end</code></pre>
      </td>
      <td>
        <em>Θ(1)</em>
      </td>
    </tr>
  </tbody>
</table>

In the examples above, *n* varies with the number of people the authenticated
user follows on Twitter. This resource returns up to 20 friends per HTTP GET,
so if the authenticated user follows 200 people, calling
`client.friends.take(20)` would make 11 HTTP requests in version 4. In version
5, it makes just 1 HTTP request. Keep in mind, eliminating a single HTTP
request to the Twitter API will reduce the latency of your application by
[about 500 ms][status].

[status]: https://dev.twitter.com/overview/status

The last example might seem contrived ("Why would I call
`client.friends.take(20)` twice?") but it applies to any
[`Enumerable`][enumerable] method you might call on a cursor, including:
`#all?`, `#collect`, `#count`, `#each`, `#inject`, `#max`, `#min`, `#reject`,
`#reverse_each`, `#select`, `#sort`, `#sort_by`, and `#to_a`. In version 4,
each time you called one of those methods, it would perform *n+1* HTTP
requests. In version 5, it only performs those HTTP requests the first time any
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

* `#all` has been replaced by `#to_a`.
* `#last` has been replaced by `#last?`.
* `#first` has been replaced by `#first?`.
* `#first` now returns the first element in the collection, as prescribed by `Enumerable`.
* `#collection` and its aliases have been removed.

### Search Results
The `Twitter::SearchResults` class has also been redesigned to have an
[`Enumerable`][enumerable] interface. The `#statuses` method and its aliases
(`#collection` and `#results`) have been replaced by `#to_a`. Additionally,
this class no longer inherits from `Twitter::Base`. As a result, the `#[]`
method has been removed.

### Trend Results
The `#trends` method now returns an [`Enumerable`][enumerable]
`Twitter::TrendResults` object instead of an array. This object provides
methods to determine the recency of the trend (`#as_of`), when the trend
started (`#created_at`), and the location of the trend (`#location`). This data
was previously unavailable.

### Geo Results
Similarly, the `#reverse_geocode`, `#geo_search`, and `#similar_places` methods
now return an [`Enumerable`][enumerable] `Twitter::GeoResults` object instead
of an array. This object provides access to the token to create a new place
(`#token`), which was previously unavailable.

### Tweets
The `Twitter::Tweet` object has been cleaned up. The following methods have been
removed:

* `#from_user`
* `#from_user_id`
* `#from_user_name`
* `#to_user`
* `#to_user_id`
* `#to_user_name`
* `#profile_image_url`
* `#profile_image_url_https`

These attributes can be accessed via the `Twitter::User` object, returned
through the `#user` method.

### Users
The `Twitter::User` object has also been cleaned up. The following aliases have
been removed:

* `#favorite_count` (use `#favorites_count`)
* `#favoriters_count` (use `#favorites_count`)
* `#favourite_count` (use `#favorites_count`)
* `#favouriters_count` (use `#favorites_count`)
* `#follower_count` (use `#followers_count`)
* `#friend_count` (use `#friends_count`)
* `#status_count` (use `#statuses_count`)
* `#tweet_count` (use `#tweets_count`)
* `#update_count` (use `#tweets_count`)
* `#updates_count` (use `#tweets_count`)
* `#translator` (use `#translator?`)

### Remove British English aliases
Earlier versions of this library aliased `favourites` to `favorites`. These
aliases have been removed. Ruby is implemented in American English. The
`initialize` method is spelled with a "z", not an "s", and Ruby provides no
alias. Likewise, this library does not provide aliases for Commonwealthers.
Merica. :us:

### More natural method names
All create, destroy, add, and remove methods have been renamed to put the verb
at the beginning:

* `#direct_message_create` is now `#create_direct_message`
* `#direct_message_destroy` is now `#destroy_direct_message`
* `#list_create` is now `#create_list`
* `#list_destroy` is now `#destroy_list`
* `#list_remove_member` is now `#remove_list_member`
* `#list_remove_members` is now `#remove_list_members`
* `#list_add_member` is now `#add_list_member`
* `#list_add_members` is now `#add_list_members`
* `#lists_owned` is now `#owned_lists`
* `#saved_search_create` is now `#create_saved_search`
* `#saved_search_destroy` is now `#destroy_saved_search`
* `#status_destroy` is now `#destroy_status`

### Null Objects
In version 4, methods you would expect to return a `Twitter` object would
return `nil` if that object was missing. This may have resulted in a
`NoMethodError`. To prevent such errors, you may have introduced checks for the
truthiness of the response, for example:

```ruby
status = client.status(55709764298092545)
if status.place
  # Do something with the Twitter::Place object
elsif status.geo
  # Do something with the Twitter::Geo object
end
```
In version 5, all such methods will return a `Twitter::NullObject` instead of
`nil`. This should prevent `NoMethodError` but may result in unexpected
behavior if you have truthiness checks in place, since everything is truthy in
Ruby except `false` and `nil`. For these cases, there are now predicate
methods:

```ruby
status = client.status(55709764298092545)
if status.place?
  # Do something with the Twitter::Place object
elsif status.geo?
  # Do something with the Twitter::Geo object
end
```

### URI Methods
The `Twitter::List`, `Twitter::Tweet`, and `Twitter::User` objects all have a
`#uri` method, which returns an HTTPS URI to twitter.com. This clobbers the
`Twitter::List#uri` method, which previously returned the list URI's path (not
a URI).

These methods are aliased to `#url` for users who prefer that nomenclature.
`Twitter::User` previously had a `#url` method, which returned the user's
website. This URI is now available via the `#website` method.

All `#uri` methods now return `Addressable::URI` objects instead of strings. To convert an
`Addressable::URI` object to a string, call `#to_s` on it.

## Configuration
Twitter API v1.1 requires you to authenticate via OAuth, so you'll need to
[register your application with Twitter][register]. Once you've registered an
application, make sure to set the correct access level, otherwise you may see
the error:

[register]: https://apps.twitter.com/

    Read-only application cannot POST

Your new application will be assigned a consumer key/secret pair and you will
be assigned an OAuth access token/secret pair for that application. You'll need
to configure these values before you make a request or else you'll get the
error:

    Bad Authentication data

You can pass configuration options as a block to `Twitter::REST::Client.new`.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

After configuration, requests can be made like so:

```ruby
client.update("I'm tweeting with @gem!")
```

**Performance/DNS settings issue**

When you are using the gem in production (running for example in a DigitalOcean VPS) be aware that DNS settings on the server can affect outbound traffic performance with `Twitter::Error::RequestTimeout` as a result. Don't use the public Google DNS services (4.4.4.4 / 8.8.8.8) they are rate-limited and have very bad response times. Use a DNS service close to your data-center.

## Usage Examples
All examples require an authenticated Twitter client. See the section on <a
href="#configuration">configuration</a>.

**Tweet (as the authenticated user)**

```ruby
client.update("I'm tweeting with @gem!")
```
**Follow a user (by screen name or user ID)**

```ruby
client.follow("gem")
client.follow(213747670)
```
**Fetch a user (by screen name or user ID)**

```ruby
client.user("gem")
client.user(213747670)
```
**Fetch a cursored list of followers with profile details (by screen name or user ID, or by implicit authenticated user)**

```ruby
client.followers("gem")
client.followers(213747670)
client.followers
```
**Fetch a cursored list of friends with profile details (by screen name or user ID, or by implicit authenticated user)**

```ruby
client.friends("gem")
client.friends(213747670)
client.friends
```

**Fetch a collection of user_ids that the currently authenticated user does not want to receive retweets from**

```ruby
client.no_retweet_ids
````

**Fetch the timeline of Tweets by a user**

```ruby
client.user_timeline("gem")
client.user_timeline(213747670)
```
**Fetch the timeline of Tweets from the authenticated user's home page**

```ruby
client.home_timeline
```
**Fetch the timeline of Tweets mentioning the authenticated user**

```ruby
client.mentions_timeline
```
**Fetch a particular Tweet by ID**

```ruby
client.status(27558893223)
```
**Collect the three most recent marriage proposals to @justinbieber**

```ruby
client.search("to:justinbieber marry me", :result_type => "recent").take(3).collect do |tweet|
  "#{tweet.user.screen_name}: #{tweet.text}"
end
```
**Find a Japanese-language Tweet tagged #ruby (excluding retweets)**

```ruby
client.search("#ruby -rt", :lang => "ja").first.text
```
For more usage examples, please see the full [documentation][].

## Object Graph

![Entity-relationship diagram][erd]

[erd]: https://cdn.rawgit.com/sferik/twitter/master/etc/erd.svg "Entity-relationship diagram"

This entity-relationship diagram is generated programatically. If you add or
remove any Twitter objects, please regenerate the ERD with the following
command:

    bundle exec rake erd

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
versions:

* Ruby 1.8.7
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1
* Ruby 2.2
* JRuby 1.7 (Both 1.9 mode and 1.8 mode)

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions,
however support will only be provided for the versions listed above.

If you would like this library to support another Ruby version or
implementation, you may volunteer to be a maintainer. Being a maintainer
entails making sure all tests run and pass on that implementation. When
something breaks on your implementation, you will be responsible for providing
patches in a timely fashion. If critical issues for a particular implementation
exist at the time of a major release, support for that Ruby version may be
dropped.

## Versioning
This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'twitter', '~> 5.0'

[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint

## Copyright
Copyright (c) 2006-2015 Erik Michaels-Ober, John Nunemaker, Wynn Netherland, Steve Richert, Steve Agalloco.
See [LICENSE][] for details.

[license]: LICENSE.md
