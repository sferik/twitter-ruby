require 'twitter/arguments'
require 'twitter/tailored_audience'
require 'twitter/tailored_audience_change'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module TailoredAudiences
      include Twitter::Ads::Utils
      include Twitter::Utils

      # Returns tailored audiences associated with the given account.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/tailored_audiences
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudience>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def tailored_audiences(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences",
                                 options, Twitter::TailoredAudience)
      end

      # Returns a specific tailored audience belonging to the given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/tailored_audiences/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudience>]
      # @param account_id [String] Ads account id.
      # @param tailored_audience_id [String] Tailored audience id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def tailored_audience(account_id, tailored_audience_id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/#{tailored_audience_id}",
                                 options, Twitter::TailoredAudience)
      end

      # Creates a tailored audience for the given account.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tailored_audiences
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudience>]
      # @param account_id [String] Ads account id.
      # @param tailored_audience_id [String] Tailored audience id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def create_tailored_audience(account_id, name, list_type)
        args = { list_type: list_type,
                 name: name }
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences",
                                 args, Twitter::TailoredAudience)
      end

      # Deletes a specific tailored audience belonging to the given account.
      #
      # @see https://dev.twitter.com/ads/reference/delete/accounts/%3Aaccount_id/tailored_audiences/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudience>]
      # @param account_id [String] Ads account id.
      # @param tailored_audience_id [String] Tailored audience id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def destroy_tailored_audience(account_id, tailored_audience_id)
        perform_delete_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/#{tailored_audience_id}",
                                   {}, Twitter::TailoredAudience)
      end

      # Returns all tailored audience changes associated with the given account.
      #
      # TODO: Cursoring
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/tailored_audience_change
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudienceChange>]
      # @param account_id [String] Ads account id.
      # @param options [Hash] customizeable options.
      def tailored_audience_changes(account_id, options = {})
        perform_get_with_objects("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audience_changes",
                                 options, Twitter::TailoredAudienceChange)
      end

      # Returns a specific tailored audience belonging to the given account.
      #
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/tailored_audiences/%3Aid
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::TailoredAudienceChange]
      # @param account_id [String] Ads account id.
      # @param tailored_audience_change_id [String] Tailored audience change id.
      # @param options [Hash] customizeable options.
      # @option options [Boolean] :with_deleted Set to true if you want deleted line items to be returned.
      def tailored_audience_change(account_id, tailored_audience_change_id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audience_changes/#{tailored_audience_change_id}",
                                options, Twitter::TailoredAudienceChange)
      end

      # Change a specified tailored audience.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tailored_audience_change
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::TailoredAudienceChange]
      # @param account_id [String] Ads account id.
      # @param tailored_audience_id [String] Tailored audience id.
      # @param input_file_path [String] File path returned by the TON data api.
      # @param operation [String] The operation to perform on the tailored audience.
      def change_tailored_audience(account_id, tailored_audience_id, input_file_path, operation)
        args = { tailored_audience_id: tailored_audience_id,
                 input_file_path: input_file_path,
                 operation: operation }
        perform_post_with_object("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audience_changes",
                                 args, Twitter::TailoredAudienceChange)
      end

      # Modify the global advertising opt-out list.
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tailored_audience_change
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::TailoredAudience>]
      # @param account_id [String] Ads account id.
      # @param input_file_path [String] File path returned by the TON data api.
      # @param list_type [String] The type of list for the audience.
      def tailored_audience_opt_out(account_id, input_file_path, list_type)
        args = { input_file_path: input_file_path,
                 list_type: list_type }
        perform_get("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/global_opt_out",
                    args)
      end
    end
  end
end
