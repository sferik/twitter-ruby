require 'twitter/funding_instrument'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module FundingInstruments
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Retrieve funding instruments associated with a specified account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/funding_instruments
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::FundingInstrument>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [Array<String>] :funding_instrument_ids Restrict listing to the provided funding instrument ids.
      # @option options [Boolean] :with_deleted Set to true if you want deleted funding instruments to be returned.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def funding_instruments(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/funding_instruments",
                                 options, Twitter::FundingInstrument)
      end

      # Retrieve a specific funding instruments associated with a specified account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/funding_instruments/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::FundingInstrument>]
      # @param account_id [String] Ads account id.
      # @param funding_instrument_id [String] The id of the funding instrument to fetch.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted funding instruments to be returned.
      def funding_instrument(account_id, funding_instrument_id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/funding_instruments/#{funding_instrument_id}",
                                options, Twitter::FundingInstrument)
      end
    end
  end
end
