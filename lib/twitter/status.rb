module Twitter
  class Status
    include EasyClassMaker
    
    attributes :created_at, :id, :text, :user, :source, :truncated, :in_reply_to_status_id, :in_reply_to_user_id, :favorited
    
    # Creates a new status from a piece of xml
    def self.new_from_xml(xml)
      s = new
      s.id                    = (xml).at('id').innerHTML
      s.created_at            = (xml).at('created_at').innerHTML
      s.text                  = (xml).get_elements_by_tag_name('text').innerHTML
      s.source                = (xml).at('source').innerHTML
      s.truncated             = (xml).at('truncated').innerHTML == 'false' ? false : true
      s.favorited             = (xml).at('favorited').innerHTML == 'false' ? false : true
      s.in_reply_to_status_id = (xml).at('in_reply_to_status_id').innerHTML
      s.in_reply_to_user_id   = (xml).at('in_reply_to_user_id').innerHTML
      s.user                  = User.new_from_xml(xml.at('user')) if (xml).at('user')
      s
    end
  end
end