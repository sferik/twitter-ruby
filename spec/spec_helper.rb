begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

dir = File.dirname(__FILE__)

$:.unshift(File.join(dir, '/../lib/'))
require dir + '/../lib/twitter'

    
def stdout_for(&block)
  # Inspired by http://www.ruby-forum.com/topic/58647
  old_stdout = $stdout
  $stdout = StringIO.new
  yield
  output = $stdout.string
  $stdout = old_stdout
  output
end