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
    module TargetingCriteria
      include Twitter::Ads::Utils
      include Twitter::Utils

      def targeting_criteria(account_id, line_item_id, options = {}); end

      def create_targeting_criterion(account_id, line_item_id, options = {}); end

      def update_targeting_criteria(account_id, line_item_id, options = {}); end

      def app_store_categories(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/app_store_categories",
                                 options, Twitter::TargetingCriterion::AppStoreCategory)
      end

      def behavior_taxonomies(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/behavior_taxonomies",
                                 options, Twitter::TargetingCriterion::BehaviorTaxonomy)
      end

      def behaviors(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/behaviors",
                                 options, Twitter::TargetingCriterion::Behavior)
      end

      def devices(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/devices",
                                 options, Twitter::TargetingCriterion::Device)
      end

      def interests(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/interests",
                                 options, Twitter::TargetingCriterion::Interest)
      end

      def languages(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/languages",
                                 options, Twitter::TargetingCriterion::Language)
      end

      def locations(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/locations",
                                 options, Twitter::TargetingCriterion::Location)
      end

      def network_operators(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/network_operators",
                                 options, Twitter::TargetingCriterion::NetworkOperator)
      end

      def platform_versions(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/platform_versions",
                                 options, Twitter::TargetingCriterion::PlatformVersion)
      end

      def platforms(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/platforms",
                                 options, Twitter::TargetingCriterion::Platform)
      end

      def tv_channels(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_channels",
                                 options, Twitter::TargetingCriterion::TVChannel)
      end

      def tv_genres(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_genres",
                                 options, Twitter::TargetingCriterion::TVGenre)
      end

      def tv_markets(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_markets",
                                 options, Twitter::TargetingCriterion::TVMarket)
      end

      def tv_shows(options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/targeting_criteria/tv_shows",
                                 options, Twitter::TargetingCriterion::TVShow)
      end
    end
  end
end
