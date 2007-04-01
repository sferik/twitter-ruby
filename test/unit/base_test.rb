require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase
  def setup
    @t = Twitter::Base.new(CONFIG['email'], CONFIG['password'])
  end
  
  test 'should have friend and public class level timelines' do
    assert_equal 3, Twitter::Base.timelines.size
  end
  
  test 'should be able to get public timeline' do
    puts 'Public Timeline', @t.timeline(:public), "*"*50
  end
  
  test 'should be able to get friends timeline' do
    puts 'Friends Timeline', @t.timeline(:friends), "*"*50
  end
  
  test 'should be able to get user timeline' do
    puts 'User Timeline', @t.timeline(:user), "*"*50
  end
  
  test 'should be able to get friends for auth user' do
    puts 'Friends', @t.friends, "*"*50
  end
  
  test 'should be able to get friends for another user' do
    puts 'Friends For', @t.friends_for('jnunemaker'), "*"*50
  end
  
  test 'should be able to get followers for auth user' do
    puts 'Followers', @t.followers, "*"*50
  end
  
  test 'should be able to get direct messages for auth user' do
    puts 'Direct Messages', @t.direct_messages, "*"*50
  end
end