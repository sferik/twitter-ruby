require 'twitter/ads/utils'
require 'twitter/card'
require 'twitter/card/app_download'
require 'twitter/card/lead_gen'
require 'twitter/card/website'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/utils'

module Twitter
  module Ads
    module Cards
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Lead-Gen

      # Returns all lead gen cards for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/lead_gen
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Card::LeadGen>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :card_ids A comma separated list of cards to lookup.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      # @option options [String] :line_item_ids A comma separated list of line item identifiers to scope the query.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def lead_gen_cards(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/lead_gen",
                                 options, Twitter::Card::LeadGen)
      end

      # Returns the specified lead gen card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/lead_gen/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::LeadGen]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def lead_gen_card(account_id, card_id)
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/lead_gen/#{card_id}",
                                {}, Twitter::Card::LeadGen)
      end

      # Creates a lead gen card for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/cards/lead_gen
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::LeadGen]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options. See documentation for additional options
      # @option params [String] :name Card name
      # @option params [String] :image_media_id Image media id.
      # @option params [String] :cta Enumeration for call-to-action button text.
      # @option params [String] :fallback_url URL to redirect users to when card cannot be presented.
      # @option params [String] :privacy_policy_url Privacy policy of the advertiser
      def create_lead_gen_card(account_id, params = {})
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/lead_gen",
                                 params, Twitter::Card::LeadGen)
      end

      # Update a lead gen card for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/cards/lead_gen/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::LeadGen]
      # @param account_id [String] Ads account id.
      # @param options [Hash] Fields to update. See documentation for options.
      def update_lead_gen_card(account_id, card_id, options = {})
        perform_put_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/lead_gen/#{card_id}",
                                options, Twitter::Card::LeadGen)
      end

      # Delete the specified lead gen card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/delete/accounts/%3Aaccount_id/cards/lead_gen/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::LeadGen]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def destroy_lead_gen_card(account_id, card_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/lead_gen/#{card_id}",
                                   {}, Twitter::Card::LeadGen)
      end

      # Mobile App Downloads

      # Returns all app download cards for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/app_download
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Card::AppDownload>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :card_ids A comma separated list of cards to lookup.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      # @option options [String] :line_item_ids A comma separated list of line item identifiers to scope the query.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def app_download_cards(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/app_download",
                                 options, Twitter::Card::AppDownload)
      end

      # Returns the specified app download card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/app_download/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::AppDownload]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def app_download_card(account_id, card_id)
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/app_download/#{card_id}",
                                {}, Twitter::Card::AppDownload)
      end

      # Creates a app download card for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/cards/app_download
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::AppDownload]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options. See documentation for additional options
      # @option params [String] :name Card name
      # @option params [String] :app_country_code 2 letter ISO country code
      # @option params [String] :iphone_app_id App Store id
      # @option params [String] :ipad_app_id App Store id
      # @option params [String] :googleplay_app_id App Store id
      def create_app_download_card(account_id, params = {})
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/app_download",
                                 params, Twitter::Card::AppDownload)
      end

      # Update a app download card for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/cards/app_download/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::AppDownload]
      # @param account_id [String] Ads account id.
      # @param options [Hash] Fields to update. See documentation for options.
      def update_app_download_card(account_id, card_id, options = {})
        perform_put_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/app_download/#{card_id}",
                                options, Twitter::Card::AppDownload)
      end

      # Delete the specified app download card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/delete/accounts/%3Aaccount_id/cards/app_download/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::AppDownload]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def destroy_app_download_card(account_id, card_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/app_download/#{card_id}",
                                   {}, Twitter::Card::AppDownload)
      end

      # Mobile App (Image)
      def app_image_cards(account_id, options = {}); end

      def app_image_card(account_id, card_id, options = {}); end

      def create_app_image_card(account_id, options = {}); end

      def update_app_image_card(account_id, options = {}); end

      def destroy_app_image_card(account_id, card_id); end

      # Website

      # Returns all website cards for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/website
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Card::Website>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [String] :card_ids A comma separated list of cards to lookup.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      # @option options [String] :line_item_ids A comma separated list of line item identifiers to scope the query.
      # @option options [String] :sort_by Set this to change the sorting of returned values.
      def website_cards(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/website",
                                options, Twitter::Card::Website)
      end

      # Returns the specified website card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/cards/website/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::Website]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def website_card(account_id, card_id)
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/website/#{card_id}",
                                {}, Twitter::Card::Website)
      end

      # Creates a website card for the given account.
      #
      # TODO: This signature is way too big. Do I switch to Twitter::Args and splat them out
      #       or just put them in options? According to the docs all these fields are required.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/cards/website
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::Website]
      # @param account_id [String] Ads account id.
      # @param name [String] Card name
      # @param title [String] Card title.
      # @param url [String] Card url.
      # @param media_id [String] Image media id.
      # @param options [Hash] customizeable options.
      # @option options [String] :website_cta Enumeration for call-to-action button text.
      def create_website_card(account_id, name, title, url, media_id, options = {})
        options = options.merge({
          name: name,
          website_title: title,
          website_url: url,
          image_media_id: media_id,
        })
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/website",
                                 options, Twitter::Card::Website)
      end

      # Updates a website card for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/cards/website/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::Website]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      # @param options [Hash] customizeable options.
      # @option options [String] :name Card name
      # @option options [String] :title Card title.
      # @option options [String] :url Card url.
      # @option options [String] :media_id Image media id.
      # @option options [String] :website_cta Enumeration for call-to-action button text.
      def update_website_card(account_id, card_id, options = {})
        perform_put_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/website/#{card_id}",
                                 options, Twitter::Card::Website)
      end;

      # Delete the specified website card for a given account.
      #
      # @see https://dev.twitter.com/ads/reference/delete/accounts/%3Aaccount_id/cards/website/%3Acard_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Card::Website]
      # @param account_id [String] Ads account id.
      # @param card_id [String] Card id.
      def destroy_website_card(account_id, card_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/cards/website/#{card_id}",
                                {}, Twitter::Card::Website)
      end
    end
  end
end
