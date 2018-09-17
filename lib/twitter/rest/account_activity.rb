require 'twitter/rest/request'
require 'twitter/rest/utils'
require 'twitter/utils'

module Twitter
  module REST
    module AccountActivity
      include Twitter::REST::Utils
      include Twitter::Utils

      #Create a webhook
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-webhooks
      def create_webhook(env_name, url)
        perform_request(:json_post, "/1.1/account_activity/all/#{env_name}/webhooks.json?url=#{url}")
      end

      #List all webhooks
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-webhooks
      def list_webhooks(env_name)
        perform_request(:get, "/1.1/account_activity/all/#{env_name}/webhooks.json")
      end

      #delete the webhook
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-webhooks-webhook-id
      def delete_webhook(env_name, webhook_id)
        perform_request(:delete, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
      end

      #Trigger a crc check
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#put-account-activity-all-env-name-webhooks-webhook-id
      def trigger_crc_check(env_name, webhook_id)
        perform_request(:json_put, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
      end

      #subscribe to a webhook
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-subscriptions
      def create_subscription(env_name)
        perform_request(:json_post, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end

      #check if webhook is subscribed by user
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-env-name-subscriptions
      def check_subscription(env_name)
        perform_request(:get, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end

      #deactivate subscription
      #API Reference: https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-subscriptions
      def deactivate_subscription(env_name)
        perform_request(:delete, "/1.1/account_activity/all/#{env_name}/subscriptions.json")
      end

    end
  end
end
