# The attributes for user are id, name, screen_name, status (which is a status object)
# new_from_xml expects xml along the lines of:
# <user>
#   <id>12796</id>
#   <name>William H Harle Jr.</name>
#   <screen_name>wharle</screen_name>
#   <location>South Bend, IN</location>
#   <description></description>
#   <profile_image_url>http://twitter.com/system/user/profile_image/12796/normal/Photo_248.jpg</profile_image_url>
#   <url>http://90percentgravity.com</url>
#   <status>
#     <created_at>Sat Jan 20 14:02:33 +0000 2007</created_at>
#     <id>3450573</id>
#     <text>proud of the weekend workout, day 4 of power 90 done</text>
#     <relative_created_at>about 15 hours ago</relative_created_at>
#   </status>
# </user>
module Twitter
  class User
    include EasyClassMaker
    
    attributes :id, :name, :screen_name, :status, :location, :description, :url, :profile_image_url
    
    class << self
      # Creates a new user from a piece of xml
      def new_from_xml(xml)
        User.new do |u|
          u.id                = (xml).at('id').innerHTML
          u.name              = (xml).at('name').innerHTML
          u.screen_name       = (xml).at('screen_name').innerHTML
          u.location          = (xml).at('location').innerHTML
          u.description       = (xml).at('description').innerHTML
          u.url               = (xml).at('url').innerHTML
          u.profile_image_url = (xml).at('profile_image_url').innerHTML
          u.status            = Status.new_from_xml(xml) if (xml).at('status')
        end
      end
    end
  end
end