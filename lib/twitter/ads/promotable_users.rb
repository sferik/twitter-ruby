require 'twitter/promotable_user'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module PromotableUsers
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns all promotable users for the supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/promotable_users
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::PromotableUser>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted campaigns to be returned.
      def promotable_users(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/promotable_users",
                                 options, Twitter::PromotableUser)
      end
    end
  end
end
