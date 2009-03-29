require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
require 'pp'

class ConfigStore
  attr_reader :file
  
  def initialize(file)
    @file = file
  end
  
  def load
    @config ||= YAML::load(open(file))
    self
  end
  
  def [](key)
    load
    @config[key]
  end
  
  def []=(key, value)
    @config[key] = value
  end
  
  def update(c={})
    @config.merge!(c)
    save
  end
  
  def save
    File.open(file, 'w') { |f| f.write(YAML.dump(@config)) }
  end
end

config = ConfigStore.new("#{ENV['HOME']}/.twitter")
oauth = Twitter::OAuth.new(config['token'], config['secret'])

if config['atoken'] && config['asecret']
  oauth.authorize_from_access(config['atoken'], config['asecret'])
  puts oauth.access_token.get("/statuses/friends_timeline.json")
  
elsif config['rtoken'] && config['rsecret']  
  oauth.authorize_from_request(config['rtoken'], config['rsecret'])
  puts oauth.access_token.get("/statuses/friends_timeline.json")
  
  config.update({
    'atoken'  => oauth.access_token.token,
    'asecret' => oauth.access_token.secret,
    'rtoken'  => nil,
    'rsecret' => nil,
  })
else
  config.update({
    'rtoken'  => oauth.request_token.token,
    'rsecret' => oauth.request_token.secret,
  })
  
  # authorize in browser
  %x(open #{oauth.request_token.authorize_url})
end