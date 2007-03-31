require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase
  def setup
    @t = Twitter::Base.new('', '')
  end
  
  test 'should have friend and public class level timelines' do
    assert_equal 3, Twitter::Base.timelines.size
  end
  
end