require 'forwardable'
require 'rubygems'

%w(oauth mash httparty).each do |lib|
  gem lib
  require lib
end

module Twitter
  class RateLimitExceeded < StandardError; end
  class Unauthorized      < StandardError; end
  class Unavailable       < StandardError; end
  class InformTwitter     < StandardError; end
  class NotFound          < StandardError; end
  class General           < StandardError; end
  
  
  def self.firehose
    response = HTTParty.get('http://twitter.com/statuses/public_timeline.json', :format => :json)
    response.map { |tweet| Mash.new(tweet) }
  end
end

directory = File.dirname(__FILE__)
$:.unshift(directory) unless $:.include?(directory)

require 'twitter/oauth'
require 'twitter/request'
require 'twitter/base'
require 'twitter/search'