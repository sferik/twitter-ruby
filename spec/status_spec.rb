require File.dirname(__FILE__) + '/spec_helper.rb'

describe Twitter::Status do
  it "should create new status from xml doc" do
    xml = <<EOF
<status>
	<created_at>Sun May 04 21:59:52 +0000 2008</created_at>
	<id>803435310</id>
	<text>Writing tests (rspec) for the twitter gem that all can run. Wish I would have done this when I wrote it years back.</text>
	<source>&lt;a href="http://iconfactory.com/software/twitterrific"&gt;twitterrific&lt;/a&gt;</source>
	<truncated>false</truncated>
	<in_reply_to_status_id></in_reply_to_status_id>
	<in_reply_to_user_id></in_reply_to_user_id>
	<favorited>false</favorited>
	<user>
		<id>4243</id>
		<name>John Nunemaker</name>
		<screen_name>jnunemaker</screen_name>
		<location>Indiana</location>
		<description>Loves his wife, ruby, notre dame football and iu basketball</description>	
			<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/52619256/ruby_enterprise_shirt_normal.jpg</profile_image_url>
		<url>http://addictedtonew.com</url>
		<protected>false</protected>
		<followers_count>363</followers_count>
	</user>
</status>
EOF
    s = Twitter::Status.new_from_xml(Hpricot.XML(xml))
    s.id.should == '803435310'
    s.created_at.should == 'Sun May 04 21:59:52 +0000 2008'
    s.text.should == 'Writing tests (rspec) for the twitter gem that all can run. Wish I would have done this when I wrote it years back.'
    s.source.should == '&lt;a href="http://iconfactory.com/software/twitterrific"&gt;twitterrific&lt;/a&gt;'
    s.truncated.should == false
    s.in_reply_to_status_id.should == ''
    s.in_reply_to_user_id.should == ''
    s.favorited.should == false
    s.user.id.should == '4243'
    s.user.name.should == 'John Nunemaker'
  end
end