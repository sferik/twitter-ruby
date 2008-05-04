require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Twitter::Status" do
  it "should create new status from xml doc" do
    xml = <<EOF
<status>
  <created_at>Sat Mar 31 06:33:21 +0000 2007</created_at>
  <id>16440221</id>
  <text>Back from underground sushi with b/c/g/j/m. Hope jack and britt get in to ratatat, too!</text>
</status> 
EOF
    s = Twitter::Status.new do |s|
      s.created_at = 'Sat Mar 31 06:33:21 +0000 2007'
      s.id = '16440221'
      s.text = 'Back from underground sushi with b/c/g/j/m. Hope jack and britt get in to ratatat, too!'
    end
    s2 = Twitter::Status.new_from_xml(Hpricot.XML(xml))
    
    s.id.should == s2.id
    s.created_at.should == s2.created_at
    s.text.should == s2.text
  end
end