require 'twitter/identity'

module Twitter
  class Stats < Twitter::Identity

    # @return [String]
    attr_reader :granularity

    # @return [Integer]
    attr_reader :total

    # @return [Array<Integer>]
    attr_reader :billed_charge_local_micro, :billed_engagements, :billed_follows,
      :estimated_charge_local_micro, :promoted_account_follows, :promoted_account_impressions,
      :promoted_account_profile_visits, :promoted_tweet_app_install_attempts,
      :promoted_tweet_app_open_attempts, :promoted_tweet_search_card_engagements,
      :promoted_tweet_search_clicks, :promoted_tweet_search_engagements,
      :promoted_tweet_search_favorites, :promoted_tweet_search_follows,
      :promoted_tweet_search_impressions, :promoted_tweet_search_replies,
      :promoted_tweet_search_retweets, :promoted_tweet_search_url_clicks,
      :promoted_tweet_timeline_card_engagements, :promoted_tweet_timeline_clicks,
      :promoted_tweet_timeline_engagements, :promoted_tweet_timeline_favorites,
      :promoted_tweet_timeline_follows, :promoted_tweet_timeline_impressions,
      :promoted_tweet_timeline_replies, :promoted_tweet_timeline_retweets,
      :promoted_tweet_timeline_url_clicks

    # @return [Array<Float>]
    attr_reader :promoted_account_follow_rate, :promoted_tweet_search_engagement_rate,
      :promoted_tweet_timeline_engagement_rate

    # @return [Hash]
    attr_reader :segment


    # Time when campaign started
    #
    # @return [Time]
    def start_time
      Time.parse(@attrs[:start_time]).utc unless @attrs[:start_time].nil?
    end

    # Time when campaign ended.
    #
    # @return [Time]
    def end_time
      Time.parse(@attrs[:end_time]).utc unless @attrs[:end_time].nil?
    end
  end
end
