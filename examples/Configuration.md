# Configuration

Twitter API version 1.1 requires authentication on all requests. Some requests
can be made with [application-only authentication][application-only] while
other requests require [single-user authentication][single-user].

[application-only]: https://dev.twitter.com/oauth/application-only
[single-user]: https://dev.twitter.com/oauth/overview/single-user

## Application-only Authentication

To start using the Twitter API, you need to [register your application with
Twitter][register]. Registration requires you to answer some questions about
your application and agree to the [Twitter API Terms of Use][api-terms].

[register]: https://apps.twitter.com/
[api-terms]: https://dev.twitter.com/overview/terms/agreement-and-policy

Once you've registered an application, it's important that you set the correct
access level. Otherwise you may see the error:

    Read-only application cannot POST

Your new application will be assigned a consumer key/secret pair that
identifies your application to Twitter. This is all you need to configure your
client for application-only authentication.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key    = "YOUR_CONSUMER_KEY"
  config.consumer_secret = "YOUR_CONSUMER_SECRET"
end
```

If you prefer, you can pass in configuration as a `Hash`:

```ruby
config = {
  consumer_key:    "YOUR_CONSUMER_KEY",
  consumer_secret: "YOUR_CONSUMER_SECRET",
}

client = Twitter::REST::Client.new(config)
```

Regardless of your configuration style, you should now be able to use this
client to make any Twitter API request that does not require single-user
authentication. For example:

```ruby
client.user("sferik")
```

Note: The first time this method is called, it will make two API requests.
First, it will fetch an access token to perform the request. Then, it will
fetch the requested user. The access token will be cached for subsequent
requests made with the same client but you may wish to manually fetch the
access token once and use it when initializing clients to avoid making two
requests every time.

```ruby
client.bearer_token
```

This token never expires and will not change unless it is invalidated. Once
you've obtained a bearer token, you can use it to initialize clients to avoid
making an extra request.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key    = "YOUR_CONSUMER_KEY"
  config.consumer_secret = "YOUR_CONSUMER_SECRET"
  config.bearer_token    = "YOUR_BEARER_TOKEN"
end
```

## Single-user Authentication

Not all Twitter API resources are accessible with application-only
authentication. Some resources require single-user authentication tokens, which
you can obtain from the [3-legged authorization][3-legged-authorization] flow.

[3-legged-authorization]: https://dev.twitter.com/oauth/3-legged

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

You can use this client to make any Twitter REST API request. For example:

```ruby
client.update("I'm tweeting with @gem!")
```

## Streaming Clients

Streaming clients are initialized just like single-user authenticated REST
clients:

```ruby
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

```ruby
client.sample do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end
```

For more information, see the documentation for the
[`Twitter::Client`][client], [`Twitter::REST::Client`][rest-client], and
[`Twitter::Streaming::Client`][streaming-client] classes.

[client]: http://rdoc.info/gems/twitter/Twitter/Client
[rest-client]: http://rdoc.info/gems/twitter/Twitter/REST/Client
[streaming-client]: http://rdoc.info/gems/twitter/Twitter/Streaming/Client

## Using a Proxy

If you'd like to connect via a proxy, a proxy can be configured by passing a
`Hash` to your configuration:

```ruby
proxy = {
  host: "proxy.example.com",
  port: 8080,
  username: "proxy_username",
  password: "proxy_password"
}

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
  config.proxy               = proxy
end
```

Note that only a `host` and `port` are required, but a `username` and `password`
can be optionally configured for an authenticated proxy server. Proxies are
supported by both [`Twitter::REST::Client`][rest-client] and
[`Twitter::Streaming::Client`][streaming-client] classes.
