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