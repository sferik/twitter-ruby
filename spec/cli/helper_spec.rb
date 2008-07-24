require 'ostruct'
require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/twitter/cli/helpers'

class Configuration; end

def say(str)
  puts str
end

describe Twitter::CLI::Helpers do
  include Twitter::CLI::Helpers
  
  describe "outputting tweets" do
    before do
      Configuration.stub!(:[]=).and_return(true)
      @collection = [
        OpenStruct.new(
          :text => 'This is my long message that I want to see formatted ooooh so pretty with a few words on each line so it is easy to scan.',
          :created_at => Time.mktime(2008, 5, 1, 10, 15, 00).strftime('%Y-%m-%d %H:%M:%S'),
          :user => OpenStruct.new(:screen_name => 'jnunemaker')
        ),
        OpenStruct.new(
          :text => 'This is my long message that I want to see formatted ooooh so pretty with a.',
          :created_at => Time.mktime(2008, 4, 1, 10, 15, 00).strftime('%Y-%m-%d %H:%M:%S'),
          :user => OpenStruct.new(:screen_name => 'danielmorrison')
        )
      ]
    end
    
    specify "should properly format" do
      output_tweets(@collection)
    end
  end
end