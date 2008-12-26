module Twitter
  class SearchResult < Hash
    
    # Creates an easier to work with hash from
    # one with string-based keys
    def self.new_from_hash(hash)
      new.merge!(hash)
    end
    
    def created_at
      self['created_at']
    end
    
    def created_at=(val)
      self['created_at'] = val
    end
    
    def from_user
      self['from_user']
    end
    
    def from_user=(val)
      self['from_user'] = val
    end
    
    def from_user_id
      self['from_user_id']
    end
    
    def from_user_id=(val)
      self['from_user_id'] = val
    end
    
    def id
      self['id']
    end
    
    def id=(val)
      self['id'] = val
    end
    
    def iso_language_code
      self['iso_language_code']
    end
    
    def iso_language_code=(val)
      self['iso_language_code'] = val
    end
    
    def profile_image_url
      self['profile_image_url']
    end
    
    def profile_image_url=(val)
      self['profile_image_url'] = val
    end
    
    def text
      self['text']
    end
    
    def text=(val)
      self['text'] = val
    end
    
    def to_user
      self['to_user']
    end
    
    def to_user=(val)
      self['to_user'] = val
    end
    
    def to_user_id
      self['to_user_id']
    end
    
    def to_user_id=(val)
      self['to_user_id'] = val
    end
    
  end
end