class Tweet < ActiveRecord::Base
  belongs_to :account
  
  def self.create_from_tweet(account, s)
    tweet             = account.tweets.find_or_initialize_by_twitter_id(s.id)
    tweet.body        = s.text
    tweet.occurred_at = s.created_at
    
    %w[truncated favorited in_reply_to_status_id in_reply_to_user_id source].each do |m|
      tweet.send("#{m}=", s.send(m))
    end
    
    %w[id followers_count name screen_name location description 
      profile_image_url url protected].each do |m|
      tweet.send("user_#{m}=", s.user.send(m))
    end
    tweet.save!
    tweet
  end
end
