require File.dirname(__FILE__) + '/../test_helper'

class DirectMessageTest < Test::Unit::TestCase
  def setup
    @xml = <<EOF
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
  end

  test 'should create new from xml' do
    d = Twitter::DirectMessage.new do |d|
      d.id                    = '331681'
      d.text                  = "thanks for revving the twitter gem! had notice that it was broken but didn't have time to patch."
      d.sender_id             = '18713'
      d.recipient_id          = '4243'
      d.created_at            = 'Sat Mar 10 22:10:37 +0000 2007'
      d.sender_screen_name    = 'al3x'
      d.recipient_screen_name = 'jnunemaker'
    end
    d2 = Twitter::DirectMessage.new_from_xml(Hpricot.XML(@xml))

    assert_equal d.id, d2.id
    assert_equal d.text, d2.text
    assert_equal d.sender_id, d2.sender_id
    assert_equal d.recipient_id, d2.recipient_id
    assert_equal d.created_at, d2.created_at
    assert_equal d.sender_screen_name, d2.sender_screen_name
    assert_equal d.recipient_screen_name, d2.recipient_screen_name
  end

end