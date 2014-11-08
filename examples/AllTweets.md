# All Tweets

This example assumes you have a configured Twitter REST `client`. Instructions
on how to configure a client can be found in [examples/Configuration.md][cfg].

[cfg]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

You can fetch up to 3,200 tweets for a user, 200 at a time.

Here is an example of recursively getting pages of 200 Tweets until you receive
an empty response.

**Note: This may result in [rate limiting][].**

[rate limiting]: https://github.com/sferik/twitter/blob/master/examples/RateLimiting.md

```ruby
def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

client.get_all_tweets("sferik")
```
