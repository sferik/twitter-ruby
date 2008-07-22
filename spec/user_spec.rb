require File.dirname(__FILE__) + '/spec_helper.rb'

describe Twitter::User do  
  it "should create new user from xml doc" do
    xml = <<EOF
<user>
  <id>18713</id>
  <name>Alex Payne</name>
  <screen_name>al3x</screen_name>
  <location>San Francisco, CA</location>
  <description>Oh, hi.  No, I just work here.</description>
  <profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/51961745/al3x_normal.jpg</profile_image_url>
  <url>http://www.al3x.net</url>
  <protected>false</protected>
  <followers_count>2889</followers_count>
  <status>
    <created_at>Sun May 04 22:38:39 +0000 2008</created_at>
    <id>803453211</id>
    <text>@5dots Yes.  Give me about 8 hours.  *sigh*</text>

    <source>&lt;a href="http://iconfactory.com/software/twitterrific"&gt;twitterrific&lt;/a&gt;</source>
    <truncated>false</truncated>
    <in_reply_to_status_id>803450314</in_reply_to_status_id>
    <in_reply_to_user_id>618923</in_reply_to_user_id>
    <favorited>false</favorited>

  </status>
</user>
EOF
    u = Twitter::User.new_from_xml(Hpricot.XML(xml))
    u.id.should == '18713'
    u.name.should =='Alex Payne'
    u.screen_name.should == 'al3x'
    u.location.should == 'San Francisco, CA'
    u.description.should == 'Oh, hi.  No, I just work here.'
    u.profile_image_url.should == 'http://s3.amazonaws.com/twitter_production/profile_images/51961745/al3x_normal.jpg'
    u.url.should == 'http://www.al3x.net'
    u.protected.should == false
    u.followers_count.should == '2889'
    u.status.text.should == '@5dots Yes.  Give me about 8 hours.  *sigh*'
  end
end