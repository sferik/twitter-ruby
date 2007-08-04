%w(uri cgi net/http yaml rubygems hpricot active_support).each { |f| require f }

require 'twitter/version'
require 'twitter/easy_class_maker'
require 'twitter/base'
require 'twitter/user'
require 'twitter/status'
require 'twitter/direct_message'