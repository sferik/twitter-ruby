# Search

You can get search results, up to 100 at a time.

Here is an example of recursively geting pages of 100 Tweets until you receive
an empty response.

**Note: This may result in [rate limiting][].**

[rate limiting]: https://github.com/sferik/twitter/blob/master/examples/RateLimiting.md

```ruby
require 'twitter'

def get_all_results(options, collection = [])
  results = @client.search(options)
  collection += results.to_a
  results.next_results? ? get_all_results(results.next_results, collection) : collection
end

get_all_results(:q => "@sferik since:#{Date.today}", :count => 100)
```
