require File.dirname(__FILE__) + '/../test_helper'

class StatusTest < Test::Unit::TestCase
  def setup
    @xml = <<EOF
<status>
  <created_at>Sat Mar 31 06:33:21 +0000 2007</created_at>
  <id>16440221</id>
  <text>Back from underground sushi with b/c/g/j/m. Hope jack and britt get in to ratatat, too!</text>
</status> 
EOF
  end
  
  test 'should create new from xml' do
    s = Twitter::Status.new do |s|
      s.created_at = 'Sat Mar 31 06:33:21 +0000 2007'
      s.id = '16440221'
      s.text = 'Back from underground sushi with b/c/g/j/m. Hope jack and britt get in to ratatat, too!'
    end
    s2 = Twitter::Status.new_from_xml(Hpricot.XML(@xml))
    
    assert_equal s.created_at, s2.created_at
    assert_equal s.id, s2.id
    assert_equal s.text, s2.text
  end
  
end