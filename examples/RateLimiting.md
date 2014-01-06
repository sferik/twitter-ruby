# Rate Limits

This example assumes you have a configured Twitter REST `client`. Instructions
on how to configure a client can be found in [examples/Configuration.md][cfg].

[cfg]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

Here's an example of how to handle rate limits:

```ruby
MAX_ATTEMPTS = 3
num_attempts = 0
begin
  num_attempts += 1
  retweets = client.retweeted_by_user("sferik")
rescue Twitter::Error::TooManyRequests => error
  if num_attempts <= MAX_ATTEMPTS
    # NOTE: Your process could go to sleep for up to 15 minutes but if you
    # retry any sooner, it will almost certainly fail with the same exception.
    sleep error.rate_limit.reset_in
    retry
  else
    raise
  end
end
```
