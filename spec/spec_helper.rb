require 'rubygems'
gem 'rspec'
require 'spec'

dir = File.dirname(__FILE__)

$:.unshift(File.join(dir, '/../lib/'))
require dir + '/../lib/twitter'