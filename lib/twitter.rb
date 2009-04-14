require 'forwardable'
require 'rubygems'

%w(oauth mash httparty).each do |lib|
  gem lib
  require lib
end

module Twitter
  class TwitterError < StandardError
    attr_reader :data
    
    def initialize(data)
      @data = data
      super
    end
  end
  
  class RateLimitExceeded < TwitterError; end
  class Unauthorized      < TwitterError; end
  class General           < TwitterError; end
  
  class Unavailable   < StandardError; end
  class InformTwitter < StandardError; end
  class NotFound      < StandardError; end
  
  
  def self.firehose
    response = HTTParty.get('http://twitter.com/statuses/public_timeline.json', :format => :json)
    response.map { |tweet| Mash.new(tweet) }
  end
  
  def self.user(id)
    response = HTTParty.get("http://twitter.com/users/show/#{id}.json", :format => :json)
    Mash.new(response)
  end
end

directory = File.dirname(__FILE__)
$:.unshift(directory) unless $:.include?(directory)

require 'twitter/oauth'
require 'twitter/httpauth'
require 'twitter/request'
require 'twitter/base'
require 'twitter/search'