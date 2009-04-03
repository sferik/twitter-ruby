%w(oauth crack).each do |lib|
  gem lib
  require lib
end

module Twitter
  class Unavailable < StandardError; end
  class CantConnect < StandardError; end
  class BadResponse < StandardError; end
  class UnknownTimeline < ArgumentError; end
  class RateExceeded < StandardError; end
  class CantFindUsers < ArgumentError; end
  class AlreadyFollowing < StandardError; end
  class CantFollowUser < StandardError; end

  SourceName = 'twittergem'
end