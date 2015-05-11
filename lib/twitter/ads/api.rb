require 'twitter/ads/accounts'
require 'twitter/ads/basic'
require 'twitter/ads/campaigns'
require 'twitter/ads/funding_instruments'
require 'twitter/ads/line_items'
require 'twitter/rest/oauth'
require 'twitter/ads/promotable_users'
require 'twitter/ads/promoted_accounts'
require 'twitter/ads/promoted_tweets'
require 'twitter/ads/tailored_audiences'

module Twitter
  module Ads
    module API
      include Twitter::Ads::Accounts
      include Twitter::Ads::Basic
      include Twitter::Ads::Campaigns
      include Twitter::Ads::FundingInstruments
      include Twitter::Ads::LineItems
      include Twitter::Ads::PromotableUsers
      include Twitter::Ads::PromotedAccounts
      include Twitter::Ads::PromotedTweets
      include Twitter::Ads::TailoredAudiences
    end
  end
end
