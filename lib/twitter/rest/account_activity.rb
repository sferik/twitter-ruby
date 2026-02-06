require "twitter/rest/request"
require "twitter/rest/utils"
require "twitter/utils"

module Twitter
  module REST
    # Methods for interacting with the Account Activity API
    module AccountActivity
      include Twitter::REST::Utils
      include Twitter::Utils

      # Registers a webhook URL for all event types
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-webhooks
      # @note Create a webhook
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.create_webhook("production", "https://example.com/webhook")
      # @param env_name [String] Environment Name
      # @param url [String] Encoded URL for the callback endpoint
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [Hash]
      def create_webhook(env_name, url)
        perform_request(:json_post, "/1.1/account_activity/all/#{env_name}/webhooks.json?url=#{url}")
      end

      # Returns all environments and webhook URLs for the app
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-webhooks
      # @note List webhooks
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.list_webhooks("production")
      # @param env_name [String] Environment Name
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [Hash]
      def list_webhooks(env_name)
        perform_request(:get, "/1.1/account_activity/all/#{env_name}/webhooks.json")
      end

      # Removes the webhook from the application's configuration
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-webhooks-webhook-id
      # @note Delete a webhook
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.delete_webhook("production", "12345")
      # @param env_name [String] Environment Name
      # @param webhook_id [String] Webhook ID
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [nil]
      def delete_webhook(env_name, webhook_id)
        perform_request(:delete, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
      end

      # Triggers the challenge response check (CRC) for a webhook
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#put-account-activity-all-env-name-webhooks-webhook-id
      # @note Trigger CRC check to a webhook
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.trigger_crc_check("production", "12345")
      # @param env_name [String] Environment Name
      # @param webhook_id [String] Webhook ID
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [nil]
      def trigger_crc_check(env_name, webhook_id)
        perform_request(:json_put, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
      end

      # Subscribes the application to all events for the environment
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-subscriptions
      # @note Subscribe the user to receive webhook events
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.create_subscription("production")
      # @param env_name [String] Environment Name
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [nil]
      def create_subscription(env_name)
        perform_request(:json_post, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end

      # Checks if the user is subscribed to the webhook
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-env-name-subscriptions
      # @note Check if the user is subscribed to the given app
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.check_subscription("production")
      # @param env_name [String] Environment Name
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [nil]
      def check_subscription(env_name)
        perform_request(:get, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end

      # Deactivates subscription for the user and application
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-subscriptions
      # @note Deactivate a subscription
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @example
      #   client.deactivate_subscription("production")
      # @param env_name [String] Environment Name
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid
      # @return [nil]
      def deactivate_subscription(env_name)
        perform_request(:delete, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end
    end
  end
end
