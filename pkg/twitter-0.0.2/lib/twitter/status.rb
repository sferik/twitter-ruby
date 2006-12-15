# The attributes are created_at, id, text, relative_created_at, and user (which is a user object)
# new_from_xml expects xml along the lines of:
# <status>
#   <id>1</id>
#   <created_at>a date</created_at>
#   <text>some text</text>
#   <relative_created_at>about 1 min ago</relative_created_at>
#   <user>
#     <id>1</id>
#     <name>John Nunemaker</name>
#     <screen_name>jnunemaker</screen_name>
#   </user>
# </status>
module Twitter
  class Status
    include EasyClassMaker
    
    attributes :created_at, :id, :text, :relative_created_at, :user
    
    class << self
      # Creates a new status from a piece of xml
      def new_from_xml(xml)
        Status.new do |s|
          s.id                  = (xml).at('id').innerHTML
          s.created_at          = (xml).at('created_at').innerHTML
          s.text                = (xml).at('text').innerHTML
          s.relative_created_at = (xml).at('relative_created_at').innerHTML
          s.user                = User.new_from_xml(xml) if (xml).at('user')
        end
      end
    end
  end
end