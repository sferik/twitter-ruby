# Update

These examples assume you have a configured Twitter REST `client`.
Instructions on how to configure a client can be found in
[examples/Configuration.md][cfg].

[cfg]: https://github.com/sferik/twitter/blob/master/examples/Configuration.md

If the authenticated user has granted read/write permission to your
application, you may tweet as them.

```ruby
client.update("I'm tweeting with @gem!")
```

Post an update in reply to another tweet.

```ruby
client.update("I'm tweeting with @gem!", in_reply_to_status_id: 402712877960019968)
```

Post an update with precise coordinates.

```ruby
client.update("I'm tweeting with @gem!", lat: 37.7821120598956, long: -122.400612831116, display_coordinates: true)
```

Post an update from a specific place. Place IDs can be retrieved using the
[`#reverse_geocode`][reverse_geocode] method.

[reverse_geocode]: http://rdoc.info/gems/twitter/Twitter/REST/API/PlacesAndGeo#reverse_geocode-instance_method

```ruby
client.update("I'm tweeting with @gem!", place_id: "df51dec6f4ee2b2c")
```

Post an update with an image.

```ruby
client.update_with_media("I'm tweeting with @gem!", File.new("/path/to/media.png"))
```

Post an update with a possibly-sensitive image.

```ruby
client.update_with_media("I'm tweeting with @gem!", File.new("/path/to/sensitive-media.png"), possibly_sensitive: true)
```

Post an update with multiple images.

```ruby
media = %w(/path/to/media1.png /path/to/media2.png).map { |filename| File.new(filename) }
client.update_with_media("I'm tweeting with @gem!", media)
```

For more information, see the documentation for the [`#update`][update] and
[`#update_with_media`][update_with_media] methods.

[update]: http://rdoc.info/gems/twitter/Twitter/REST/Tweets#update-instance_method
[update_with_media]: http://rdoc.info/gems/twitter/Twitter/REST/Tweets#update_with_media-instance_method
