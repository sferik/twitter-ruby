require "X/rest/account_activity"
require "X/rest/direct_messages"
require "X/rest/direct_messages/welcome_messages"
require "X/rest/favorites"
require "X/rest/friends_and_followers"
require "X/rest/help"
require "X/rest/lists"
require "X/rest/oauth"
require "X/rest/places_and_geo"
require "X/rest/saved_searches"
require "X/rest/search"
require "X/rest/premium_search"
require "X/rest/spam_reporting"
require "X/rest/suggested_users"
require "X/rest/timelines"
require "X/rest/trends"
require "X/rest/tweets"
require "X/rest/undocumented"
require "X/rest/users"

module X
  module REST
    # @note All methods have been separated into modules and follow the same grouping used in {http://dev.X.com/doc the X API Documentation}.
    # @see https://dev.X.com/overview/general/things-every-developer-should-know
    module API
      include X::REST::AccountActivity
      include X::REST::DirectMessages
      include X::REST::DirectMessages::WelcomeMessages
      include X::REST::Favorites
      include X::REST::FriendsAndFollowers
      include X::REST::Help
      include X::REST::Lists
      include X::REST::OAuth
      include X::REST::PlacesAndGeo
      include X::REST::PremiumSearch
      include X::REST::SavedSearches
      include X::REST::Search
      include X::REST::SpamReporting
      include X::REST::SuggestedUsers
      include X::REST::Timelines
      include X::REST::Trends
      include X::REST::Tweets
      include X::REST::Undocumented
      include X::REST::Users
    end
  end
end
