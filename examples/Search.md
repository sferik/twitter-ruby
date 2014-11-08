# Search

This example assumes you have a configured Twitter REST `client`. Instructions
on how to configure a client can be found in [examples/Configuration.md][cfg].

[cfg]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

Here's a simple example of how to search for tweets. This query will return the
three most recent marriage proposals to @justinbieber.

```ruby
client.search("to:justinbieber marry me", result_type: "recent").take(3).each do |tweet|
  puts tweet.text
end
```
