require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase
  def setup
    # note to self use webgroup
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
  
  test 'should be able to get featured users' do
    puts 'Featured', @t.featured, "*"*50
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
  
  test 'should be able to get direct messages for auth user by alias received messages' do
    puts 'Recieved Messages', @t.received_messages, "*"*50
  end
  
  test 'should be able to send a direct message' do
    @t.d('jnunemaker', 'just testing')
  end
  
  test 'should be able to get sent messages for auth user' do
    puts 'Sent Messages', @t.sent_messages, "*"*50
  end
  
  test 'should be able to get a status by id' do
    puts "Status 185005122", @t.status(185005122).inspect, "*"*50
  end
  
  test 'should be able to get replies for auth user' do
    puts "Replies", @t.replies, "*"*50
  end
  
  test "should be able to get a user's info" do
    puts "User", @t.user('jnunemaker').inspect, "*"*50
  end
  
  test 'should be able to create and destroy friendships' do
    puts "Destroying Friendship", @t.destroy_friendship('jnunemaker'), "*"*50
    puts "Creating Friendship", @t.create_friendship('jnunemaker'), "*"*50
  end
  
  test 'should be able to follow a user' do
    puts "Following a user", @t.follow('jnunemaker'), "*"*50
  end
  
  test 'should be able to leave a user' do
    puts "Leaving a user", @t.leave('jnunemaker'), "*"*50
  end
  
  
  test 'should be able to destroy a status' do
    # this has to be checked individually, create a status, put the id in and make sure it was deleted
    #@t.destroy(185855442)
  end
  
  test 'should be able to destroy a direct message' do
    # must be tested individually
    @t.destroy_direct_message(4687032)
  end
end