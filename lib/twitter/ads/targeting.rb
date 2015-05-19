require 'twitter/ads/utils'
require 'twitter/arguments'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/settings'
require 'twitter/targeting_criterion/app_store_category'
require 'twitter/targeting_criterion/behavior'
require 'twitter/targeting_criterion/behavior_taxonomy'
require 'twitter/targeting_criterion/device'
require 'twitter/targeting_criterion/interest'
require 'twitter/targeting_criterion/language'
require 'twitter/targeting_criterion/location'
require 'twitter/targeting_criterion/network_operator'
require 'twitter/targeting_criterion/platform'
require 'twitter/targeting_criterion/platform_version'
require 'twitter/targeting_criterion/tv_channel'
require 'twitter/targeting_criterion/tv_genre'
require 'twitter/targeting_criterion/tv_markets'
require 'twitter/targeting_criterion/tv_show'
require 'twitter/utils'

module Twitter
  module Ads
    module Targeting
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns targeting criteria associated with a specified line item
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/targeting_criteria
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion>]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Line item to retrieve criteria for
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted criteria to be returned.
      def targeting_criteria(account_id, line_item_id, options = {}); end

      # Returns targeting specified targeting criterion.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/targeting_criteria/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::TargetingCriterion]
      # @param account_id [String] Ads account id.
      # @param criterion_id [String] Desired criterion's id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted criteria to be returned.
      def targeting_criterion(account_id, criterion_id, options = {}); end

      # Creates a targeting criterion and adds it to a specified line item.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/targeting_criteria
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::TargetingCriterion]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Desired line item's id.
      # @param targeting_type [String] Type of targeting that will be applied.
      # @param targeting_value [String,Integer] The targeting value to use in targeting.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :tailored_audience_expansion Set to true to expand audience (CRM only).
      def create_targeting_criterion(account_id, line_item_id, targeting_type, targeting_value, options = {}); end

      # Update the targeting criteria for a specific line item.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/targeting_criteria
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion>]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Line item id.
      # @param options [Hash] customizeable options. See documentation for options.
      def update_targeting_criteria(account_id, line_item_id, options = {}); end

      # Returns app store category based targeting criteria. App store categories are for
      # iOS App Store and Google Play only.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/app_store_categories
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::AppStoreCategory>]
      # @param options [Hash] customizeable options.
      # @option options [String] :store Scope results to a specific app store (IOS_APP_STORE, GOOGLE_PLAY).
      # @option options [String] :q Query to scope results.
      def app_store_categories(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/app_store_categories",
                                 options, Twitter::TargetingCriterion::AppStoreCategory)
      end

      # Returns full or partial structure of behavior taxonomy trees.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/behavior_taxonomies
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::BehaviorTaxonomy>]
      # @param options [Hash] customizeable options.
      # @option options [String] :behavior_taxonomy_ids Comma separated list of taxonomy ids to filter the response.
      # @option options [String] :parent_behavior_taxonomy_ids Limit results to the children of a comma separated list of taxonomy ids.
      def behavior_taxonomies(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/behavior_taxonomies",
                                 options, Twitter::TargetingCriterion::BehaviorTaxonomy)
      end

      # Return all valid behaviors that can be targeted
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/behaviors
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Behavior>]
      # @param options [Hash] customizeable options.
      # @option options [String] :behavior_ids Comma separated list of identifiers to filter by
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def behaviors(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/behaviors",
                                 options, Twitter::TargetingCriterion::Behavior)
      end

      # Returns device-based targeting criteria.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/devices
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Device>]
      # @param options [Hash] customizeable options.
      # @option options [String] :q Query to scope results.
      def devices(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/devices",
                                 options, Twitter::TargetingCriterion::Device)
      end

      # Returns interest-based targeting criteria.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/interests
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Interest>]
      # @param options [Hash] customizeable options.
      # @option options [String] :q Query to scope results.
      def interests(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/interests",
                                 options, Twitter::TargetingCriterion::Interest)
      end

      # Returns language-based targeting criteria.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/languages
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Language>]
      # @param options [Hash] customizeable options.
      # @option options [String] :q Query to scope results.
      def languages(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/languages",
                                 options, Twitter::TargetingCriterion::Language)
      end

      # Returns location-based targeting criteria.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/locations
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Location>]
      # @param options [Hash] customizeable options.
      # @option options [String] :country_code Two letter ISO country code to restrict search
      # @option options [String] :location_type Type of location to lookup (COUNTRY, REGION, CITY, POSTAL_CODE).
      # @option options [String] :q Query to scope results.
      def locations(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/locations",
                                 options, Twitter::TargetingCriterion::Location)
      end

      # Returns mobile network operator based targeting criteria.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/network_operators
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::NetworkOperator>]
      # @param options [Hash] customizeable options.
      # @option options [String] :country_code Two letter ISO country code to restrict search
      # @option options [String] :q Query to scope results.
      def network_operators(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/network_operators",
                                 options, Twitter::TargetingCriterion::NetworkOperator)
      end

      # Returns mobile os version based targeting criteria.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/platform_versions
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::NetworkOperator>]
      # @param options [Hash] customizeable options.
      # @option options [String] :q Query to scope results.
      def platform_versions(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/platform_versions",
                                 options, Twitter::TargetingCriterion::PlatformVersion)
      end

      # Returns platform-based targeting criteria.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/platforms
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::Platform>]
      # @param options [Hash] customizeable options.
      # @option options [String] :q Query to scope results.
      def platforms(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/platforms",
                                 options, Twitter::TargetingCriterion::Platform)
      end

      # Returns TV channels for network targeting.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/tv_channels
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::TVChannel>]
      # @param options [Hash] customizeable options.
      # @option options [String] :tv_market_locale BCP 47 language code of locale to return results for.
      def tv_channels(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_channels",
                                 options, Twitter::TargetingCriterion::TVChannel)
      end

      # Returns TV genres for targeting.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/tv_genres
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::TVGenre>]
      def tv_genres
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_genres",
                                 {}, Twitter::TargetingCriterion::TVGenre)
      end

      # Returns TV markets for targeting.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/tv_markets
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::TVMarket>]
      def tv_markets(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_markets",
                                 options, Twitter::TargetingCriterion::TVMarket)
      end

      # Returns TV shows for targeting.
      #
      # @see https://dev.twitter.com/ads/reference/get/targeting_criteria/tv_shows
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TargetingCriterion::TVShow>]
      # @option options [String] :tv_market_locale BCP 47 language code of locale to return results for.
      # @option options [String] :q Query to scope results.
      def tv_shows(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_shows",
                                 options, Twitter::TargetingCriterion::TVShow)
      end
    end
  end
end
