require 'twitter/promoted_account'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module PromotedAccounts
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Retrieve promoted accounts associated with a specified account.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/promoted_accounts
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotedAccount>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :line_item_ids Restrict listing to accounts associated to the specified line item.
      # @option options [Array<String>] :promoted_account_ids Restrict listing to the provided promoted account ids.
      # @option options [Boolean] :with_deleted Set to true if you want deleted funding instruments to be returned.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def promoted_accounts(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_accounts",
                                 options, Twitter::PromotedAccount)
      end

      # Associate a user account to the specified line item.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/funding_instruments/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotedAccount>]
      # @param account_id [String] Ads account id.
      # @param line_item_id [String] The line item id to associate the promoted account with.
      # @param user_id [String] The twitter user account id promote.
      def promote_account(account_id, line_item_id, user_id)
        args = {
          line_item_id: line_item_id,
          user_id: user_id,
        }
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_accounts",
                                args, Twitter::PromotedAccount)
      end
    end
  end
end
