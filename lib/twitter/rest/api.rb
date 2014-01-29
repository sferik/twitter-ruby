require 'twitter/rest/direct_messages'
require 'twitter/rest/favorites'
require 'twitter/rest/friends_and_followers'
require 'twitter/rest/help'
require 'twitter/rest/lists'
require 'twitter/rest/oauth'
require 'twitter/rest/places_and_geo'
require 'twitter/rest/saved_searches'
require 'twitter/rest/search'
require 'twitter/rest/spam_reporting'
require 'twitter/rest/suggested_users'
require 'twitter/rest/timelines'
require 'twitter/rest/trends'
require 'twitter/rest/tweets'
require 'twitter/rest/undocumented'
require 'twitter/rest/users'

module Twitter
  module REST
    module API
      [
        Twitter::REST::DirectMessages,
        Twitter::REST::Favorites,
        Twitter::REST::FriendsAndFollowers,
        Twitter::REST::Help,
        Twitter::REST::Lists,
        Twitter::REST::OAuth,
        Twitter::REST::PlacesAndGeo,
        Twitter::REST::SavedSearches,
        Twitter::REST::Search,
        Twitter::REST::SpamReporting,
        Twitter::REST::SuggestedUsers,
        Twitter::REST::Timelines,
        Twitter::REST::Trends,
        Twitter::REST::Tweets,
        Twitter::REST::Undocumented,
        Twitter::REST::Users,
      ].each do |klass|
        include klass
      end
    end
  end
end
