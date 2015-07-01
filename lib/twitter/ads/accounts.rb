require 'twitter/account'
require 'twitter/ads/utils'
require 'twitter/arguments'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/settings'
require 'twitter/tweet'
require 'twitter/utils'

module Twitter
  module Ads
    module Accounts
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns all accounts.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Account>]
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted accounts to be returned.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def accounts(options = {})
        perform_get_with_objects('https://ads-api.twitter.com/0/accounts', options, Twitter::Account)
      end

      # Returns a specified account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Account>]
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted accounts to be returned.
      def account(id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{id}", options, Twitter::Account)
      end

      # Retrieve up to 200 of the most recent promotable Tweets created by one or more
      # specified Twitter users.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/scoped_timeline
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>]
      # @param account_id [String] Ads account id.
      # @param user_ids [Array<Integer>, Array<String>, String, Integer] Array of twitter user ids or comma separated string of ids
      # @param options [Hash] customizeable options.
      # @option options [String] :scoped_to Scope search. See documentation for options.
      # @option options [String] :objective Objective type to restrict timeline to.
      # @option options [Boolean] :trim_user set to true to only receive user id rather than the full profile.
      def scoped_timeline(id, user_ids, options = {})
        ids = [user_ids].flatten.join(',')
        options = options.merge(user_ids: ids)
        perform_get_with_cursor("https://ads-api.twitter.com/0/accounts/#{id}/scoped_timeline", options,
                                :data, Twitter::Tweet)
      end
    end
  end
end
