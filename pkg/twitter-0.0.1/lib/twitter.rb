%w(uri net/http yaml rubygems hpricot).each { |f| require f }

require 'twitter/version'
require 'twitter/easy_class_maker'
require 'twitter/base'
require 'twitter/user'
require 'twitter/status'