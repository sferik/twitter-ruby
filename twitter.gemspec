# -*- encoding: utf-8 -*-
# stub: twitter 8.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "twitter".freeze
  s.version = "8.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Erik Berlin".freeze, "John Nunemaker".freeze, "Wynn Netherland".freeze, "Steve Richert".freeze, "Steve Agalloco".freeze]
  s.date = "2023-07-29"
  s.description = "A Ruby interface to the Twitter API.".freeze
  s.email = ["sferik@gmail.com".freeze]
  s.files = [".yardopts".freeze, "CHANGELOG.md".freeze, "CONTRIBUTING.md".freeze, "LICENSE.md".freeze, "README.md".freeze, "lib/twitter.rb".freeze, "lib/twitter/arguments.rb".freeze, "lib/twitter/base.rb".freeze, "lib/twitter/basic_user.rb".freeze, "lib/twitter/client.rb".freeze, "lib/twitter/creatable.rb".freeze, "lib/twitter/cursor.rb".freeze, "lib/twitter/direct_message.rb".freeze, "lib/twitter/direct_message_event.rb".freeze, "lib/twitter/direct_messages/welcome_message.rb".freeze, "lib/twitter/direct_messages/welcome_message_rule.rb".freeze, "lib/twitter/direct_messages/welcome_message_rule_wrapper.rb".freeze, "lib/twitter/direct_messages/welcome_message_wrapper.rb".freeze, "lib/twitter/entities.rb".freeze, "lib/twitter/entity.rb".freeze, "lib/twitter/entity/hashtag.rb".freeze, "lib/twitter/entity/symbol.rb".freeze, "lib/twitter/entity/uri.rb".freeze, "lib/twitter/entity/user_mention.rb".freeze, "lib/twitter/enumerable.rb".freeze, "lib/twitter/error.rb".freeze, "lib/twitter/factory.rb".freeze, "lib/twitter/geo.rb".freeze, "lib/twitter/geo/point.rb".freeze, "lib/twitter/geo/polygon.rb".freeze, "lib/twitter/geo_factory.rb".freeze, "lib/twitter/geo_results.rb".freeze, "lib/twitter/headers.rb".freeze, "lib/twitter/identity.rb".freeze, "lib/twitter/language.rb".freeze, "lib/twitter/list.rb".freeze, "lib/twitter/media/animated_gif.rb".freeze, "lib/twitter/media/photo.rb".freeze, "lib/twitter/media/video.rb".freeze, "lib/twitter/media/video_info.rb".freeze, "lib/twitter/media_factory.rb".freeze, "lib/twitter/metadata.rb".freeze, "lib/twitter/null_object.rb".freeze, "lib/twitter/oembed.rb".freeze, "lib/twitter/place.rb".freeze, "lib/twitter/premium_search_results.rb".freeze, "lib/twitter/profile.rb".freeze, "lib/twitter/profile_banner.rb".freeze, "lib/twitter/rate_limit.rb".freeze, "lib/twitter/relationship.rb".freeze, "lib/twitter/rest/account_activity.rb".freeze, "lib/twitter/rest/api.rb".freeze, "lib/twitter/rest/client.rb".freeze, "lib/twitter/rest/direct_messages.rb".freeze, "lib/twitter/rest/direct_messages/welcome_messages.rb".freeze, "lib/twitter/rest/favorites.rb".freeze, "lib/twitter/rest/form_encoder.rb".freeze, "lib/twitter/rest/friends_and_followers.rb".freeze, "lib/twitter/rest/help.rb".freeze, "lib/twitter/rest/lists.rb".freeze, "lib/twitter/rest/oauth.rb".freeze, "lib/twitter/rest/places_and_geo.rb".freeze, "lib/twitter/rest/premium_search.rb".freeze, "lib/twitter/rest/request.rb".freeze, "lib/twitter/rest/saved_searches.rb".freeze, "lib/twitter/rest/search.rb".freeze, "lib/twitter/rest/spam_reporting.rb".freeze, "lib/twitter/rest/suggested_users.rb".freeze, "lib/twitter/rest/timelines.rb".freeze, "lib/twitter/rest/trends.rb".freeze, "lib/twitter/rest/tweets.rb".freeze, "lib/twitter/rest/undocumented.rb".freeze, "lib/twitter/rest/upload_utils.rb".freeze, "lib/twitter/rest/users.rb".freeze, "lib/twitter/rest/utils.rb".freeze, "lib/twitter/saved_search.rb".freeze, "lib/twitter/search_results.rb".freeze, "lib/twitter/settings.rb".freeze, "lib/twitter/size.rb".freeze, "lib/twitter/source_user.rb".freeze, "lib/twitter/streaming/client.rb".freeze, "lib/twitter/streaming/connection.rb".freeze, "lib/twitter/streaming/deleted_tweet.rb".freeze, "lib/twitter/streaming/event.rb".freeze, "lib/twitter/streaming/friend_list.rb".freeze, "lib/twitter/streaming/message_parser.rb".freeze, "lib/twitter/streaming/response.rb".freeze, "lib/twitter/streaming/stall_warning.rb".freeze, "lib/twitter/suggestion.rb".freeze, "lib/twitter/target_user.rb".freeze, "lib/twitter/trend.rb".freeze, "lib/twitter/trend_results.rb".freeze, "lib/twitter/tweet.rb".freeze, "lib/twitter/user.rb".freeze, "lib/twitter/utils.rb".freeze, "lib/twitter/variant.rb".freeze, "lib/twitter/version.rb".freeze, "twitter.gemspec".freeze]
  s.homepage = "https://sferik.github.io/twitter/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.4.13".freeze
  s.summary = "A Ruby interface to the Twitter API.".freeze

  s.installed_by_version = "3.4.13" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.3"])
  s.add_runtime_dependency(%q<buftok>.freeze, ["~> 0.3.0"])
  s.add_runtime_dependency(%q<equalizer>.freeze, ["~> 0.0.11"])
  s.add_runtime_dependency(%q<http>.freeze, ["~> 5.1"])
  s.add_runtime_dependency(%q<http-form_data>.freeze, ["~> 2.3"])
  s.add_runtime_dependency(%q<llhttp-ffi>.freeze, ["~> 0.4.0"])
  s.add_runtime_dependency(%q<memoizable>.freeze, ["~> 0.4.0"])
  s.add_runtime_dependency(%q<multipart-post>.freeze, ["~> 2.0"])
  s.add_runtime_dependency(%q<naught>.freeze, ["~> 1.0"])
  s.add_runtime_dependency(%q<simple_oauth>.freeze, ["~> 0.3.0"])
end
