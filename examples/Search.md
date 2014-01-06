# Search

Here is a simple demonstration of how to get tweets using this gem. 

See the [Configuration][] example for info about keys/tokens/secrets. 

[Configuration]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

```ruby
require 'twitter'

client = Twitter::REST::Client.new do |config
  config.consumer_key = "YOUR_CONSUMER_KEY"
  config.consumer_secret = "YOUR_CONSUMER_SECRET"
  config.access_token = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end

client.search("#helloworld", :count => 10).each do |tweet| 
  puts "#{tweet.user.name} (@#{tweet.user.screen_name}): #{tweet.text} [Created #{tweet.created_at}]"
end
```
