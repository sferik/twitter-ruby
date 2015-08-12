require 'twitter/ads/utils'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/settings'
require 'twitter/stats'
require 'twitter/utils'

module Twitter
  module Ads
    module Statistics
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns stats specific to a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def account_stats(account_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}", options)
      end

      # Returns a stats specific to a given campaign.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/campaigns/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param campaign_id [String] An ads campaign id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def campaign_stats(account_id, campaign_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/campaigns/#{campaign_id}", options)
      end

      # Returns a stats specific to a given line item.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/line_items/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param line_item_id [String] An ads line_item id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def line_item_stats(account_id, line_item_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/line_items/#{line_item_id}", options)
      end

      # Returns a stats specific to a given promoted tweet.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/promoted_tweets/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param promoted_tweet_id [String] An ads promoted tweet id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def promoted_tweet_stats(account_id, promoted_tweet_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/promoted_tweets/#{promoted_tweet_id}", options)
      end

      # Returns a stats specific to a given promoted account.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/promoted_accounts/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param promoted_account_id [String] An ads promoted account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def promoted_account_stats(account_id, promoted_account_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/promoted_accounts/#{promoted_account_id}", options)
      end

      # Returns a stats specific to a given funding instrument.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/funding_instruments/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param funding_instrument_id [String] An ads funding instrument id.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def funding_instrument_stats(account_id, funding_instrument_id, options = {})
        perform_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/funding_instruments/#{funding_instrument_id}", options)
      end

      # Return aggregate stats specific to a collection of campaigns
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/campaigns
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param campaign_ids [Array<String>] Ads campaign ids.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def campaigns_stats(account_id, campaign_ids, options = {})
        perform_collection_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/campaigns",
                                        campaign_ids, :campaign_ids,  options)
      end

      # Return aggregate stats specific to a collection of line items.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/line_items
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param line_item_ids [Array<String>] Ads line item ids.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def line_items_stats(account_id, line_item_ids, options = {})
        perform_collection_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/line_items",
                                        line_item_ids, :line_item_ids,  options)
      end

      # Return aggregate stats specific to a collection of promoted tweets.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/promoted_tweets
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param promoted_tweet_ids [Array<String>] Ads promoted tweet ids.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def promoted_tweets_stats(account_id, promoted_tweet_ids, options = {})
        perform_collection_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/promoted_tweets",
                                        promoted_tweet_ids, :promoted_tweet_ids,  options)
      end

      # Return aggregate stats specific to a collection of promoted accounts.
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/promoted_accounts
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param promoted_account_ids [Array<String>] Ads promoted account ids.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def promoted_accounts_stats(account_id, promoted_account_ids, options = {})
        perform_collection_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/promoted_accounts",
                                        promoted_account_ids, :promoted_account_ids,  options)
      end

      # Return aggregate stats specific to a collection of funding instruments
      #
      # @see https://dev.twitter.com/ads/reference/get/stats/accounts/%3Aaccount_id/funding_instruments
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Stats, Array<Twitter::Stats>]
      # @param account_id [String] An ads account id.
      # @param funding_instrument_ids [Array<String>] Ads funding instrument ids.
      # @param options [Hash] customizeable options.
      # @option options [String] :start_time Scopes retrieved data to this ISO8601 start time.
      # @option options [String] :end_time Scopes retrieved data to this ISO8601 end time.
      # @option options [String] :granularity Specify the granularity. Defaults to 'HOUR'.
      # @option options [String] :metrics Comma separated list of metrics to return.
      # @option options [String] :segmentation_type The desired segmentation.
      # @option options [String] :country A country targeting_value required for certain segmentation types.
      # @option options [String] :platform A platform targeting_value required for certain segmentation types.
      def funding_instruments_stats(account_id, funding_instrument_ids, options = {})
        perform_collection_get_for_stats("https://ads-api.twitter.com/0/stats/accounts/#{account_id}/funding_instruments",
                                        funding_instrument_ids, :funding_instrument_ids,  options)
      end

    private

      # If you elect for segmentation twitter returns an array of stats objects rather
      # than a single stats object.
      def perform_get_for_stats(url, options, klass = Twitter::Stats)
        if options.has_key?(:segmentation_type) || options.has_key?('segmentation_type')
          perform_get_with_objects(url, options, klass)
        else
          perform_get_with_object(url, options, klass)
        end
      end

      def perform_collection_get_for_stats(url, ids, key, options, klass = Twitter::Stats)
        options[key] = case ids
                       when String then ids
                       when Array then ids.join(',')
                       else raise 'Ids must be a string or array of strings.'
                       end
        perform_get_with_objects(url, options, klass)
      end
    end
  end
end
