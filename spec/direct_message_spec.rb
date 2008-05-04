require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Twitter::DirectMessage" do
  it "should create new direct message from xml doc" do
    xml = <<EOF
<direct_message>
  <id>331681</id>
  <text>thanks for revving the twitter gem! had notice that it was broken but didn't have time to patch.</text>
  <sender_id>18713</sender_id>
  <recipient_id>4243</recipient_id>
  <created_at>Sat Mar 10 22:10:37 +0000 2007</created_at>
  <sender_screen_name>al3x</sender_screen_name>
  <recipient_screen_name>jnunemaker</recipient_screen_name>
</direct_message>
EOF
    d = Twitter::DirectMessage.new do |d|
      d.id                    = '331681'
      d.text                  = "thanks for revving the twitter gem! had notice that it was broken but didn't have time to patch."
      d.sender_id             = '18713'
      d.recipient_id          = '4243'
      d.created_at            = 'Sat Mar 10 22:10:37 +0000 2007'
      d.sender_screen_name    = 'al3x'
      d.recipient_screen_name = 'jnunemaker'
    end
    d2 = Twitter::DirectMessage.new_from_xml(Hpricot.XML(xml))
    
    d.id.should == d2.id
    d.text.should == d2.text
    d.sender_id.should == d2.sender_id
    d.recipient_id.should == d2.recipient_id
    d.created_at.should == d2.created_at
    d.sender_screen_name.should == d2.sender_screen_name
    d.recipient_screen_name.should == d2.recipient_screen_name
  end
end