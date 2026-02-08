# The Twitter Ruby Gem

[![Lint](https://github.com/sferik/twitter-ruby/actions/workflows/lint.yml/badge.svg)](https://github.com/sferik/twitter-ruby/actions/workflows/lint.yml)
[![Test](https://github.com/sferik/twitter-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/sferik/twitter-ruby/actions/workflows/test.yml)
[![Mutant](https://github.com/sferik/twitter-ruby/actions/workflows/mutant.yml/badge.svg)](https://github.com/sferik/twitter-ruby/actions/workflows/mutant.yml)
[![Typecheck](https://github.com/sferik/twitter-ruby/actions/workflows/typecheck.yml/badge.svg)](https://github.com/sferik/twitter-ruby/actions/workflows/typecheck.yml)
[![Yardstick](https://github.com/sferik/twitter-ruby/actions/workflows/yardstick.yml/badge.svg)](https://github.com/sferik/twitter-ruby/actions/workflows/yardstick.yml)
[![Gem Version](https://badge.fury.io/rb/twitter.svg)][gem]

The Twitter Ruby Gem provides a Ruby interface to the X (Twitter) API v1.1.

For new projects, or if you need API v2 support, use the [X gem][x] as a more
modern alternative. It supports both API v1.1 and API v2.

[x]: https://sferik.github.io/x-ruby/
[gem]: https://rubygems.org/gems/twitter

## 💖 Sponsoring
Open source maintenance takes real time and effort. By sponsoring development,
you help us:

1. 🛠  Maintain the library: Keeping it up-to-date and secure.
2. 🌈 Add new features: Enhancements that make your life easier.
3. 💬 Provide support: Faster responses to issues and feature requests.

⭐️ Bonus: Sponsors will get priority support and influence over the project
roadmap. We will also list your name or your company’s logo on our GitHub page.

Building and maintaining an open-source project like this takes a considerable
amount of time and effort. Your sponsorship can help sustain this project. Even
a small monthly donation makes a huge difference!

Thanks for considering sponsorship. Together we can make the X gem even better!

#### 🤑 [Sponsor today!][sponsor]

[sponsor]: https://github.com/sponsors/sferik

## Announcements
You should [follow @gem][follow] on X for announcements and updates about
this library.

[follow]: https://x.com/gem

## Configuration
Twitter API v1.1 requests require OAuth credentials, so you'll need to
[register an app in the X developer portal][register] first.

[register]: https://developer.x.com/en/portal/dashboard

After creating an app, you'll have a consumer key/secret pair and an access
token/secret pair. Configure these before making requests.

You can pass configuration options as a block to `Twitter::REST::Client.new`.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

## Usage Examples
After configuring a `client`, you can do the following things.

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

**Fetch a cursored list of followers (by screen name, user ID, or the authenticated user)**

```ruby
client.followers("gem")
client.followers(213747670)
client.followers
```

**Fetch a cursored list of friends (by screen name, user ID, or the authenticated user)**

```ruby
client.friends("gem")
client.friends(213747670)
client.friends
```

**Fetch the timeline of Tweets by a user**

```ruby
client.user_timeline("gem")
client.user_timeline(213747670)
```

**Fetch the home timeline**

```ruby
client.home_timeline
```

**Fetch the mentions timeline**

```ruby
client.mentions_timeline
```

**Fetch a Tweet by ID**

```ruby
client.status(27558893223)
```

**Search recent matching Tweets**

```ruby
client.search("to:justinbieber marry me", result_type: "recent").take(3).map do |tweet|
  "#{tweet.user.screen_name}: #{tweet.text}"
end
```

**Find a Japanese-language Tweet tagged #ruby (excluding retweets)**

```ruby
client.search("#ruby -rt", lang: "ja").first.text
```

For more usage examples, see the full [documentation][].

[documentation]: https://rubydoc.info/gems/twitter

## Streaming
This gem includes streaming clients for legacy API v1.1 streaming endpoints.
Endpoint availability and access requirements depend on your developer account.

**Configuration works just like `Twitter::REST::Client`**

```ruby
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

**Stream a random sample of Tweets**

```ruby
client.sample do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end
```

**Stream mentions of coffee or tea**

```ruby
topics = ["coffee", "tea"]
client.filter(track: topics.join(",")) do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end
```

**Stream Tweets, events, and direct messages for the authenticated user**

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
* `Twitter::Tweet`
* `Twitter::DirectMessage`
* `Twitter::Streaming::DeletedTweet`
* `Twitter::Streaming::Event`
* `Twitter::Streaming::FriendList`
* `Twitter::Streaming::StallWarning`

## Copyright
Copyright (c) 2006-2026 Erik Berlin, John Nunemaker, Wynn Netherland, Steve Richert, Steve Agalloco.
See [LICENSE][] for details.

[license]: LICENSE.md
