# Streaming

This example assumes you have a configured Twitter Streaming `client`.
Instructions on how to configure a client can be found in
[examples/Configuration.md][cfg].

[cfg]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

Here's a simple example of how to stream tweets from San Francisco:

```ruby
client.filter(locations: "-122.75,36.8,-121.75,37.8") do |tweet|
  puts tweet.text
end
```
