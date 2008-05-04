require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Twitter::User" do  
  it "should create new user from xml doc" do
    xml = <<EOF
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
    u = Twitter::User.new do |u|
      u.id = '18713'
      u.name = 'Alex Payne'
      u.screen_name = 'al3x'
      u.location = 'Arlington, VA'
      u.description = 'A description'
      u.profile_image_url = 'http://static.twitter.com/system/user/profile_image/18713/normal/361219175_c11b881657.jpg?1171954960'
      u.url = 'http://www.al3x.net'
    end

    u2 = Twitter::User.new_from_xml(Hpricot.XML(xml))
    
    u.id.should == u2.id
    u.name.should == u2.name
    u.screen_name.should == u2.screen_name
    u.location.should == u2.location
    u.description.should == u2.description
    u.profile_image_url.should == u2.profile_image_url
    u.url.should == u2.url
  end
end