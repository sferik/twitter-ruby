# The attributes for user are id, name, screen_name, status (which is a status object)
# new_from_xml expects xml along the lines of:
# <user>
#   <id>1</id>
#   <name>John Nunemaker</name>
#   <screen_name>jnunemaker</screen_name>
#   <status>
#     <id>1</id>
#     <created_at>a date</created_at>
#     <text>some text</text>
#     <relative_created_at>about 1 min ago</relative_created_at>
#   </status>
# </user>
module Twitter
  class User
    include EasyClassMaker
    
    attributes :id, :name, :screen_name, :status
    
    class << self
      # Creates a new user from a piece of xml
      def new_from_xml(xml)
        User.new do |u|
          u.id            = (xml).at('id').innerHTML
          u.name          = (xml).at('name').innerHTML
          u.screen_name   = (xml).at('screen_name').innerHTML
          u.status        = Status.new_from_xml(xml) if (xml).at('status')
        end
      end
    end
  end
end