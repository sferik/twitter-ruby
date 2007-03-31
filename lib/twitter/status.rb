module Twitter
  class Status
    include EasyClassMaker
    
    attributes :created_at, :id, :text, :user
    
    class << self
      # Creates a new status from a piece of xml
      def new_from_xml(xml)
        Status.new do |s|
          s.id         = (xml).at('id').innerHTML
          s.created_at = (xml).at('created_at').innerHTML
          s.text       = (xml).at('text').innerHTML
          s.created_at = (xml).at('created_at').innerHTML
          s.user       = User.new_from_xml(xml) if (xml).at('user')
        end
      end
    end
  end
end