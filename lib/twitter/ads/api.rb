require 'twitter/ads/accounts'
require 'twitter/ads/campaigns'
require 'twitter/ads/line_items'
require 'twitter/rest/oauth'

module Twitter
  module Ads
    module API
      include Twitter::Ads::Accounts
      include Twitter::Ads::Campaigns
      include Twitter::Ads::LineItems
    end
  end
end
