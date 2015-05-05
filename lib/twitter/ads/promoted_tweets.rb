require 'twitter/arguments'
require 'twitter/promoted_tweet'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module PromotedTweets
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Retrieve references to promoted tweets associated with an account and optionally
      # specific line items
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/promoted_tweets
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotedTweet>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :line_item_id Restrict listing to accounts associated to the specified line item.
      # @option options [Boolean] :with_deleted Set to true if you want deleted funding instruments to be returned.
      def promoted_tweets(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets",
                                 options, Twitter::PromotedTweet)
      end

      # Promote tweets in association with a specified line item
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/promoted_tweets
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotedTweet>]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Id of the line item to associate with the promoted tweet
      # @param tweet_ids [String] Comma separated list of status ids to promote
      def promote_tweet(account_id, line_item_id, tweet_ids)
        opts = { line_item_id: line_item_id,
                 tweet_ids: tweet_ids }
        perform_post_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets",
                                  opts, Twitter::PromotedTweet)

      end

      # Delete a promoted tweet record.
      #
      # @see https://dev.twitter.com/ads/reference/delete/accounts/%3Aaccount_id/promoted_tweets/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotedTweet>]
      # @param account_id [String] Ads account id.
      # @param promoted_tweet_id [String] Id of the promoted tweet record.
      def destroy_promoted_tweet(account_id, promoted_tweet_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets/#{promoted_tweet_id}",
                                   {}, Twitter::PromotedTweet)
      end
    end
  end
end
