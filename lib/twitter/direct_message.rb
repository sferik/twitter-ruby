module Twitter
  class DirectMessage
    include EasyClassMaker
    
    attributes :id, :text, :sender_id, :recipient_id, :created_at, :sender_screen_name, :recipient_screen_name
    
    class << self
      # Creates a new status from a piece of xml
      def new_from_xml(xml)
        DirectMessage.new do |d|
          d.id                    = (xml).at('id').innerHTML
          d.text                  = (xml).get_elements_by_tag_name('text').innerHTML
          d.sender_id             = (xml).at('sender_id').innerHTML
          d.recipient_id          = (xml).at('recipient_id').innerHTML
          d.created_at            = (xml).at('created_at').innerHTML
          d.sender_screen_name    = (xml).at('sender_screen_name').innerHTML
          d.recipient_screen_name = (xml).at('recipient_screen_name').innerHTML
        end
      end
    end
  end
end