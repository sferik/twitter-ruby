require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    @xml = <<EOF
<user>
  <id>18713</id>
  <name>Alex Payne</name>
  <screen_name>al3x</screen_name>
  <location>Arlington, VA</location>
  <description>A description</description>
  <profile_image_url>http://static.twitter.com/system/user/profile_image/18713/normal/361219175_c11b881657.jpg?1171954960</profile_image_url>
  <url>http://www.al3x.net</url>
</user>
EOF
  end
  
  test 'should create a new from xml' do
    u = Twitter::User.new do |u|
      u.id = '18713'
      u.name = 'Alex Payne'
      u.screen_name = 'al3x'
      u.location = 'Arlington, VA'
      u.description = 'A description'
      u.profile_image_url = 'http://static.twitter.com/system/user/profile_image/18713/normal/361219175_c11b881657.jpg?1171954960'
      u.url = 'http://www.al3x.net'
    end
    
    u2 = Twitter::User.new_from_xml(Hpricot.XML(@xml))
    
    assert_equal u.id, u2.id
    assert_equal u.name, u2.name
    assert_equal u.screen_name, u2.screen_name
    assert_equal u.location, u2.location
    assert_equal u.description, u2.description
    assert_equal u.profile_image_url, u2.profile_image_url
    assert_equal u.url, u2.url
  end
  
end