require 'twitter/base'

module Twitter
  class Language < Twitter::Base
    attr_reader :code, :name, :status
  end

  def code
   @attrs.code
end
def name
   @attrs.name
end
def status
   @attrs.status
end

end
