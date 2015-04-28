require 'twitter/arguments'
require 'twitter/line_item'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module LineItems
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns all line items for a supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/line_items
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::LineItem>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :campaign_ids A comma separated list of campaign identifiers to scope the query.
      # @option options [String] :line_item_ids A comma separated list of line item identifiers to scope the query.
      # @option options [String] :funding_instrument_ids A comma separated list of funding instrument identifiers to scope the query.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      # @option options [Integer] :count Specifies the number of line items to retrieve.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def line_items(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/line_items",
                                 options, Twitter::LineItem)
      end

      # Returns a specific line item for a supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/line_items/%3Aline_item_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::LineItem]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Line item id
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def line_item(account_id, line_item_id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/line_items/#{line_item_id}",
                                options, Twitter::LineItem)
      end

      # Returns a specific line item for a supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/line_items
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::LineItem]
      # @param account_id [String] Ads account id.
      # @param campaign_id [String] Ads campaign id.
      # @param options [Hash] customizeable options.
      # @option options [Integer] :bid_amount_local_micro The bid amount for this line item (Amount*1e6).
      # @option options [Boolean] :automatically_select_bid Set this to true to allow Twitter to automatically optimize bidding.
      # @option options [String] :placement_type Type of promoted product (TODO: Twitter::Placement enumeration?)
      # @option options [String] :objective The line item objective (TODO: Twitter::Objective enumeration?)
      # @option options [Boolean] :paused Set this to true to pause the line item.
      # @option options [String] :include_sentiment Set to ALL to target positive and negative tweets
      # @option options [Integer] :total_budget_amount_local_micro The total budget amount (Amount*1e6).
      # @option options [String] :optimization Change the optimization setting (TODO: Twitter::Optimization enumeration?)
      # @option options [String] :bid_unit Change bid unit based on objective (TODO: Twitter::Optimization enumeration?)
      def create_line_item(account_id, campaign_id, options = {})
        options = options.merge(campaign_id: campaign_id)
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/line_items",
                                 options, Twitter::LineItem)
      end

      # Update a specific line item for a supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/line_items/%3Aline_item_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::LineItem]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Line item id
      # @param options [Hash] customizeable options.
      # @option options [Integer] :bid_amount_local_micro The bid amount for this line item (Amount*1e6).
      # @option options [String] :include_sentiment Set to ALL to target positive and negative tweets
      # @option options [Integer] :total_budget_amount_local_micro The total budget amount (Amount*1e6).
      # @option options [String] :optimization Change the optimization setting (TODO: Twitter::Optimization enumeration?)
      def update_line_item(account_id, line_item_id, options = {})
        perform_put_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/line_items/#{line_item_id}",
                                options, Twitter::LineItem)
      end

      # Delete specific line item for a supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/line_items/%3Aline_item_id
      # @rate_limited Yes # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::LineItem]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] Line item id
      def destroy_line_item(account_id, line_item_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/line_items/#{line_item_id}",
                                {}, Twitter::LineItem)
      end
    end
  end
end
