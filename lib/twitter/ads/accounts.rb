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

      # TODO: Cursoring
      # TODO: Documentation
      def accounts(options = {})
        perform_get_with_objects('https://ads-api.twitter.com/0/accounts', options, Twitter::Account)
      end

      # TODO: Documentation
      def account(id, options = {})
        perform_get_with_object("https://ads-api.twitter.com/0/accounts/#{id}", options, Twitter::Account)
      end
    end
  end
end
