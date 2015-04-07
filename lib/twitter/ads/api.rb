require 'twitter/ads/accounts'
require 'twitter/ads/campaigns'
require 'twitter/rest/oauth'

module Twitter
  module Ads
    module API
      include Twitter::Ads::Accounts
      include Twitter::Ads::Campaigns
    end
  end
end
