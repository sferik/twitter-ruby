require 'test_helper'

class TwitterTest < Test::Unit::TestCase

  should "default User Agent to 'Ruby Twitter Gem'" do
    assert_equal 'Ruby Twitter Gem', Twitter.user_agent
  end

  context 'when overriding the user agent' do
    should "be able to specify the User Agent" do
      Twitter.user_agent = 'My Twitter Gem'
      assert_equal 'My Twitter Gem', Twitter.user_agent
    end
  end

end
