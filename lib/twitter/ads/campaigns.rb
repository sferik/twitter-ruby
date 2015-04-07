require 'twitter/arguments'
require 'twitter/campaign'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module Campaigns
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns all campaigns for the supplied account id
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/campaigns
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Campaign>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [Array<String>] :campaign_ids Restrict listing to the provided campaign ids.
      # @option options [Array<String>] :funding_instrument_ids Restrict listing to campaigns funded with te provided instruments.
      # @option options [Boolean] :with_deleted Set to true if you want deleted campaigns to be returned.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def campaigns(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/campaigns", options, Twitter::Campaign)
      end

      # Returns a specific campaign belonging to an account
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/campaigns/%3Acampaign_id
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param account_id [String] An ads account id.
      # @param campaign_id [String] The id of the campaign to fetch.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set this to true to retrieve a deleted campaign.
      def campaign(account_id, campaign_id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/campaigns/#{campaign_id}",
                                options, Twitter::Campaign)
      end
    end
  end
end
