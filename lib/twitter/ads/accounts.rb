require 'twitter/account'
require 'twitter/arguments'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
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
    end
  end
end
