require 'uri'
require 'cgi'
require 'net/http'
require 'yaml'
require 'time'
require 'rubygems'
require 'hpricot'

$:.unshift(File.dirname(__FILE__))
require 'twitter/version'
require 'twitter/easy_class_maker'
require 'twitter/base'
require 'twitter/user'
require 'twitter/search'
require 'twitter/status'
require 'twitter/direct_message'
require 'twitter/rate_limit_status'
require 'twitter/search_result_info'
require 'twitter/search_result'

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