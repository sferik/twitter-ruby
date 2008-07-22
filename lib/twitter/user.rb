module Twitter
  class User    
    include EasyClassMaker
    
    attributes  :id, :name, :screen_name, :status, :location, :description, :url,
                :profile_image_url, :profile_background_color, :profile_text_color, :profile_link_color, 
                :profile_sidebar_fill_color, :profile_sidebar_border_color, :friends_count, :followers_count,
                :favourites_count, :statuses_count, :utc_offset , :protected
    
    # Creates a new user from a piece of xml
    def self.new_from_xml(xml)
      u = new
      u.id                           = (xml).at('id').innerHTML
      u.name                         = (xml).at('name').innerHTML
      u.screen_name                  = (xml).at('screen_name').innerHTML
      u.location                     = (xml).at('location').innerHTML
      u.description                  = (xml).at('description').innerHTML
      u.url                          = (xml).at('url').innerHTML
      u.profile_image_url            = (xml).at('profile_image_url').innerHTML          
      
      # optional, not always present
      u.profile_background_color     = (xml).at('profile_background_color').innerHTML if (xml).at('profile_background_color')
      u.profile_text_color           = (xml).at('profile_text_color').innerHTML if (xml).at('profile_text_color')
      u.profile_link_color           = (xml).at('profile_link_color').innerHTML if (xml).at('profile_link_color')
      u.profile_sidebar_fill_color   = (xml).at('profile_sidebar_fill_color').innerHTML if (xml).at('profile_sidebar_fill_color')
      u.profile_sidebar_border_color = (xml).at('profile_sidebar_border_color').innerHTML if (xml).at('profile_sidebar_border_color')
      u.friends_count                = (xml).at('friends_count').innerHTML if (xml).at('friends_count')
      u.followers_count              = (xml).at('followers_count').innerHTML if (xml).at('followers_count')
      u.favourites_count             = (xml).at('favourites_count').innerHTML if (xml).at('favourites_count')
      u.statuses_count               = (xml).at('statuses_count').innerHTML if (xml).at('statuses_count')
      u.utc_offset                   = (xml).at('utc_offset').innerHTML if (xml).at('utc_offset')
      u.protected                    = (xml).at('protected').innerHTML == 'false' ? false : true if (xml).at('protected')
      u.status                       = Status.new_from_xml(xml.at('status')) if (xml).at('status')
      u
    end
  end
end